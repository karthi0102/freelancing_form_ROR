# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do

    section "New Projects",style:"margin:24px" do
      table_for Project.order(created_at: :desc).limit(5) do
        column :name
        column "Owner",:client
      end
      strong {link_to "View All Projects" ,admin_projects_path}
    end

    section "New Accounts",style:"margin:24px" do
      table_for Account.order(created_at: :desc).limit(5) do
        column :name
        column :email
        column :phone
        column "Owner",:accountable
      end
      strong {link_to "View All Accounts" ,admin_accounts_path}
    end

    section "Completed Projects",style:"margin:24px" do
      table_for ProjectStatus.order(updated_at: :desc).where(status: "completed").limit(5) do
          column :project
          column "Completed at",:updated_at
      end
    end



    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
