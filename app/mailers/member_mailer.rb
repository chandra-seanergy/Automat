class MemberMailer < ApplicationMailer
  def success_add(group, profile_name, mail_ids)
    @profile_name=profile_name
    @group=group
    mail(to: mail_ids, subject: "Access to the #{group.name} group was granted")
  end
end
