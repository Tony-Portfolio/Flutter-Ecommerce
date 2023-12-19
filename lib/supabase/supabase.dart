import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> initializeSupabase() async {
  await Supabase.initialize(
    url: 'https://midlsoyjkxifqakotayb.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1pZGxzb3lqa3hpZnFha290YXliIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTY5MTY0NDksImV4cCI6MjAxMjQ5MjQ0OX0.Pi6E8xXOmDWEZv7MpYbPiT5Vgfw6HEq4w5GzlMZkdR0',
  );

  await Supabase.instance.client.auth.signInWithPassword(
    email: 'xxdjtonygo@gmail.com',
    password: '123321',
  );
}

final supabase = Supabase.instance.client;
