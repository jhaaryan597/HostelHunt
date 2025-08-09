-- Drop the old function and trigger
drop trigger if exists on_auth_user_created on auth.users;
drop function if exists public.handle_new_user;

-- Create the updated function
create function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, full_name, avatar_url)
  values (
    new.id,
    new.raw_user_meta_data->>'full_name',
    new.raw_user_meta_data->>'avatar_url'
  );
  return new;
end;
$$;

-- Create the trigger again
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
