class BatchesController < ApplicationController

    def index
        @batches = Batches.all 
    end

    def show
        @batch = Batch.find(params[:id])
    end

    def new
        @batch = Batch.new
    end

    def create
        @batch = Batch.new(batch_params)
        respond_to do |format|
            if @batch.save
                format.html { redirect_to @batch, notice: "Batch successfully created" }
            else
                format.html { render :new } 
            end
        end
    end

    private

    def batch_params
        params.require(:batch).permit(:urls)
    end

end