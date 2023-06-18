class ProfileController < ApplicationController
  def client
    @client = Client.find_by(id: params[:id])
    i=0;
    @rating=0;
    @client.account.recipient_feedbacks.each do |feedback|
      i+=1
      @rating=@rating+feedback.rating
    end
    @rating=@rating/i
  end

  def freelancer
    @freelancer = Freelancer.find_by(id: params[:id])
    i=0;
    @rating=0;
    @freelancer.account.recipient_feedbacks.each do |feedback|
      i+=1
      @rating=@rating+feedback.rating
    end
    @rating=@rating/i
  end

end
