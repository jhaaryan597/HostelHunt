-- Drop the old function and trigger
drop trigger if exists on_auth_user_created on auth.users;
drop function if exists public.handle_new_user;

-- Create the updated function
create table public.users (
  id uuid not null,
  fullname text not null,
  email text not null,
  username text not null,
  profile_image_url text null,
  constraint users_pkey primary key (id),
  constraint users_id_fkey foreign key (id) references auth.users (id) on delete cascade
);

alter table public.users enable row level security;

create policy "Public users are viewable by everyone."
on users for select
using ( true );

create policy "Users can insert their own user."
on users for insert
with check ( auth.uid() = id );

create policy "Users can update own user."
on users for update
using ( auth.uid() = id );

-- Create the function to handle new user creation
create function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.users (id, fullname, email, username)
  values (new.id, new.raw_user_meta_data->>'full_name', new.email, new.raw_user_meta_data->>'username');
  return new;
end;
$$;

-- Create the trigger to call the function after a new user is created
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
