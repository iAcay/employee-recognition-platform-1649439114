module AdminUsers
  class CategoriesController < BaseController
    def index
      render :index, locals: { categories: Category.all.order(title: :asc) }
    end

    def new
      render :new, locals: { category: Category.new }
    end

    def edit
      render :edit, locals: { category: category }
    end

    def create
      record = Category.new(category_params)

      if record.save
        redirect_to admin_users_categories_path, notice: 'Category was successfully created.'
      else
        render :new, locals: { category: record }
      end
    end

    def update
      if category.update(category_params)
        redirect_to admin_users_categories_path, notice: 'Category was successfully updated.'
      else
        render :edit, locals: { category: category }
      end
    end

    def destroy
      if category.destroy
        redirect_to admin_users_categories_url, notice: 'Category was successfully destroyed.'
      else
        redirect_to admin_users_categories_path,
                    notice: 'This category cannot be deleted because of its relations with existing rewards.'
      end
    end

    private

    def category
      @category ||= Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:title)
    end
  end
end
