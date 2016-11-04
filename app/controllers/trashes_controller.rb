class TrashesController < ApplicationController
  
  def index
    @trash = Trash.all
    
    # respond_to do |format|
    #   format.html
    #   format.pdf do
    #     pdf = TrashPdf.new(@trash)
    #     send_data pdf.render, filename: 'trashReport.pdf', type: 'application/pdf'
    #   end
    # end
  end
  
  def trash_report
    @trash = Trash.all
    
    respond_to do |format|
      format.html
      format.pdf do
        pdf = TrashPdf.new(@trash)
        send_data pdf.render, filename: 'trashReport.pdf', type: 'application/pdf', :disposition => 'attachment'
      end
    end
  end

end
