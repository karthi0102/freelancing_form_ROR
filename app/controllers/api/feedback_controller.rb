class Api::FeedbackController < Api::ApiController
    before_action :is_freelancer ,only: [:freelancer_to_client,:team_to_client]
    before_action :is_client ,only: [:client_to_freelancer,:client_to_team]
    def show
      account = Account.find_by(id: params[:id])
      if account
        if account.recipient_feedbacks.empty?
          render json:{message:"No feedback found"},status: :ok
        else
          render json:account.recipient_feedbacks,status: :ok
        end
      else
        render json:{message:"Account not found"},status: :ok
      end
    end
    def freelancer_to_client
        feedback_data = feedback_params
        freelancer = Account.find_by(id: feedback_data["from"].to_i)
        client = Account.find_by(id: feedback_data["to"].to_i)
        if freelancer and client
          feedback = Feedback.new(created:freelancer ,recipient:client ,comment:feedback_data["comment"],rating:feedback_data["rating"])
          if feedback.save
            render json:{message:"Feedback created",feedback:feedback},status: :ok
          else
            render json:{message:"Error while creating feedback",error:feedback.errors},status: :ok
          end
        else
          render json:{message:"Unknown action"},status: :ok
        end
    end

    def team_to_client
      feedback_data=feedback_params
      team = Team.find_by(id: feedback_data["from"].to_i)
      client = Account.find_by(id: feedback_data["to"].to_i)
      p team
      p client
      if team and client
          freelancer = team.admin
          feedback = Feedback.new(created:freelancer.account ,recipient:client ,comment:feedback_data["comment"],rating:feedback_data["rating"])
          if feedback.save
            render json:{message:"Feedback created",feedback:feedback},status: :ok
          else
            render json:{message:"Error while creating feedback",error:feedback.errors},status: :ok
          end
      else
        render json:{message:"Unknown action"},status: :ok
      end
    end

    def client_to_freelancer
      feedback_data = feedback_params
      freelancer = Account.find_by(id: feedback_data["to"].to_i)
      client = Account.find_by(id: feedback_data["from"].to_i)
      project_member = ProjectMember.find_by(id: feedback_data["member_id"].to_i)
      puts
      if freelancer and client and project_member
        feedback = Feedback.new(comment: feedback_data["comment"], rating:feedback_data["rating"],created:client,recipient:freelancer)
        if feedback.save and project_member.update(feedback:true)
          render json:{message:"Feedback created",feedback:feedback,project_member:project_member},status: :ok
        else
          render json:{message:"Error",errors:[feedback.errors,project_member.errors]},status: :ok
        end
      else
        render json:{message:"Unknown action"},status: :ok
      end
    end


    def client_to_team
      feedback_data = feedback_params
      team = Team.find_by(id:feedback_data["to"].to_i)
      project_member = ProjectMember.find_by(id: feedback_data["member_id"].to_i)
      client = Account.find_by(id: feedback_data["from"].to_i)
      if team and client and project_member
        feedbacks=[]
        team.freelancers.each do |member|
          feedback = Feedback.new(created:client,recipient:member.account,rating:feedback_data["rating"],comment:feedback_data["comment"])
          unless feedback.save
            render json:{message:"Error",error:feedback.errors},status: :ok
          else
            feedbacks<<feedback
          end
        end
        if project_member.update(feedback: true)
          render json:{message:"Feedback created",feedbacks:feedbacks,project_member:project_member},status: :ok
        else
          render json:{message:"Feedback created but error in updating project member"},status: :ok
        end
      else
        render json:{message:"Unknown action"},status: :ok
      end
    end



    private
    def feedback_params
      params.require(:feedback).permit(:comment,:rating,:to,:from,:member_id)
    end

    def is_client
      unless  current_account.client?
        render json:{message:"Unauthorized action"},status: :forbidden
      end
    end

    def is_freelancer
      unless  current_account.freelancer?
        render json:{message:"Unauthorized action"},status: :forbidden
      end
    end



end
