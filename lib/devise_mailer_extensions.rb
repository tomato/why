module DeviseMailerExtensions 

  def self.included(base)
    base.class_eval do
      alias_method_chain :mailer_sender, :supplier_email
    end
  end
  

  def mailer_sender_with_supplier_email(mapping)
    if @resource.respond_to?(:supplier)
      "#{@resource.supplier.friendly_id}@fromwhereitsgrown.com"
    else
      mailer_sender_without_supplier_email(mapping)
    end
  end

  # Deliver an invitation email
  def invitation_instructions(record)
    setup_mail(record, :invitation_instructions)
  end

end


