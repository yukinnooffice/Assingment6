# 応用課題2
## エラー箇所

### サーバー起動時
1. rails s -b 0.0.0.0ができない

routes.rb:
```ruby
  :
    get 'home/about'
+ end
```



### サーバー起動後(ログインページ)
2. SyntaxError

users_controller.rb:
```ruby
  :
   def index
     @users = User.all
     @book = Book.new
+  end
  :
```

3. このページは動作していません(立ち上げれない)

routes.rb: 順序入れ替え
```ruby
+  devise_for :users
   resources :users,only: [:show,:index,:edit,:update]
   resources :books
-  devise_for :users
```

4. Sass::syntaxError

Gemfile:
```ruby
   :
   gem 'jquery-rails'
+  gem 'bootstrap-sass', '~> 3.4.1'
```
→ `bundle install`

5. ヘッダー以外のレイアウトが表示されない

application.html.erb:
```HTML+ERB
   :
   <div class="container">
     <p id="notice"><%= notice %></p>
+    <%= yield %>
   </div>
   :
```

### サインアップをする前
6. ヘッダーのhome,aboutアイコンを押してもLoginの画面のまま

application_controller.rb:
```ruby
   class ApplicationController < ActionController::Base
-	   before_action :authenticate_user!
     :
```

books_controller.rb:
```ruby
   class BooksController < ApplicationController
+	   before_action :authenticate_user!
     :
```

users_controller.rb:
```ruby
   class UsersController < ApplicationController
+	   before_action :authenticate_user!
     :
```


7. homeアイコンを押すとNameError

home/top.html.erb:
```HTML+ERB
-  <p><%=link_to "Log in", new_user_sessions_path, ...
+  <p><%=link_to "Log in", new_user_session_path, ...
```

```HTML+ERB
-  <p><%=link_to "Sign up", new_user_registrations_path, ...
+  <p><%=link_to "Sign up", new_user_registration_path, ...
```


### サインアップ時
8. NoMethodError undefined method 'name_field'

devise/registrations/new.html.erb:
```HTML+ERB
-  <%= f.name_field :name, ...
+  <%= f.text_field :name, ...
```


9. 新規会員登録できない(Books must exist)

user.rb:
```ruby
-  belongs_to :books
+  has_many :books
```

10. ログイン後にtopページが表示されてしまう

application_controller.rb:
```ruby
   def after_sign_in_path_for(resource)
-    root_path
+    user_path(resource)
   end
```


### users/show
11. NameError undefind local variable or method 'books'

users/show.html.erb:
```HTML+ERB
-  <% books.each do |book| %>
+  <% @books.each do |book| %>
```

12. bootstrapを使ったレイアウトができていない

users/show.html.erb:
```HTML+ERB
+  <div class="row">
+    <div class="col-xs-3">
	     <h2>User info</h2>
	     :
	     <%= render 'books/newform', book: @book %>
+	   </div>
+	   <div class="col-xs-9">
		   <h2>Books</h2>
       :
		   <!--books一覧 -->
+	   </div>
+  </div>

```

### users/edit
13. NomethodError undefind method 'title'

users/edit.html.erb:
```HTML+ERB
-  <%= f.label :title %>
-  <%= f.text_field :title, class: "name" %>
+  <%= f.label :name %>
+  <%= f.text_field :name, class: "name" %>
```

14. プロフィール編集が成功・失敗した後

users_controller.rb:
```ruby
   def update
     @user = User.find(params[:id])
     if @user.update(user_params)
-      redirect_to users_path(@user), notice: "successfully updated user!"
+      redirect_to user_path(@user), notice: "successfully updated user!"
     else
-      render "show"
+      render "edit"
     end
   end
```

config/initializers/application_controller_renderer.rb:
```ruby
   :
+  Refile.secret_key = 表示された内容
```

### users/index
15. ActionView::MissingTemplate

users/index.html.erb:
```HTML+ERB
-  <%= render 'newform', book: @book %>
+  <%= render 'books/newform', book: @book %>
```

16. bootstrapを使ったレイアウトができていない

→ 12と同じように追加

### books/index
17. ArgumentError

books_controller.rb:
```ruby
   def index
     @books = Book.all
+    @book = Book.new
   end
```
18. undefined method 'to_model' ☆追加

book.rb:
```ruby
-  has_many :user
+  belongs_to :user
```

19. 本の投稿ができない: エラーメッセージが表示されない ☆変更

books/index.html.erb:
```HTML+ERB
   <div class="row">
+  <% if @book.errors.any? %>
+    <div id="error_explanation">
+      <h3><%= @book.errors.count %>error prohibited this obj from being saved:</h3>
+      <ul>
+        <% @book.errors.full_messages.each do |message| %>
+          <li><%= message %></li>
+        <% end %>
+      </ul>
+    </div>
+  <% end %>
   <div class="col-xs-3">
```


20. 本の投稿ができない: データが保存できない ☆追加、変更

books_controller.rb:
```ruby
   def create
  	 @book = Book.new(book_params)
+  	 @book.user_id = current_user.id
  	 if @book.save
  		 redirect_to book_path(@book), notice: "successfully created book!"
  	 else
  		 @books = Book.all
  		 render 'index'
  	 end
   end
```

```ruby
   def book_params
-   	params.require(:book).permit(:title)
+   	params.require(:book).permit(:title, :body)
   end
```

### books/show
21. NameError undefined local variable or method 'user'

books/show.html.erb:
```HTML+ERB
-  <%= render 'users/profile' %>
+  <%= render 'users/profile', user: @book.user %>
```


22. 本の詳細ページで新規投稿フォームが編集フォームになっている

→ 問題になっていなかった。

books/show.html.erb:
[問題修正]
```HTML+ERB
-  <%= render 'books/newform' %>
+  <%= render 'books/newform', book: @book %>
```

[解答]
```HTML+ERB
-  <%= render 'books/newform', book: @book %>
+  <%= render 'books/newform', book: Book.new %>
```



## books/destroy
23. 本の投稿が削除できない

books_controller.rb:
```ruby
-  def delete
+  def destroy
     @book = Book.find(params[:id])
-    @book.destoy
+    @book.destroy
     redirect_to books_path, notice: "successfully delete book!"
   end
```

### ログアウト時
24. Rspecで大半が`Undefined method 'profile_image_id' for User`

→(一例)
```Linux Kernel Module
rm db/development.sqlite3
rails g migration AddProfileImageIdToUsers profile_image_id:string
rails db:migrate
rails db:migrate RAILS_ENV=test
```

25. introductionカラムにバリデーションが設定されていない

user.rb:
```ruby
   validates :name, length: {maximum: 20, minimum: 2}
+  validates :introduction, length: {maximum: 50}
```

26. 本の編集時にもエラー文が表示されない ☆変更

→ 19と同じように、books/edit.html.erbにコードを追加。

27. ヘッダーの文字を見本に合わせる<br>

→ `Home` `About` `sign up` `login` / `Home` `Users` `Books` `logout`

28. 他ユーザーのプロフィールを編集できないようにする

users_controller.rb:
```ruby
-  before_action :baria_user, only: [:update]
+  before_action :baria_user, only: [:edit, :update]
```
(baria_userの中身分かりにくい気がする...)

29. 他ユーザーが投稿した本の編集、削除のリンクを表示させない

books/show.html.erb:
```HTML+ERB
+  <% if @book.user == current_user %>
     <td><%= link_to "Edit", ...
     <td><%= link_to "Destroy", ...
+  <% end %>

```

30. ログイン中にURLを入力すると他人が投稿した本の編集ページに遷移できないようにする

→複数解あるが一例。

books_controller.rb:
```ruby
+    before_action :ensure_correct_user, only: [:edit, :update, :destroy]
     private
     :
+    def ensure_correct_user
+      @book = Book.find(params[:id])
+      unless @book.user == current_user
+        redirect_to books_path
+      end
+    end
   end
```

edit,update,destroyアクション内
```ruby
-  @book = Book.find(params[:id])
```

---

ex. ActiveRecord Couldn't find User with 'id'=user

→ リダイレクト先はおかしいが、問題が成立せず。問題削除。

[問題修正]
application_controller.rb:
```ruby
   def after_sign_out_path_for(resource)
-    user_path(resource)
+    root_path
   end
```
# Assingment4
