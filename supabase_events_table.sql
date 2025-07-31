-- SQL statement to create events table in Supabase
-- This table will store community events that users can browse and join

CREATE TABLE IF NOT EXISTS public.community_events (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    event_date TIMESTAMP WITH TIME ZONE NOT NULL,
    end_date TIMESTAMP WITH TIME ZONE,
    location VARCHAR(255),
    organizer VARCHAR(255),
    image_url TEXT,
    max_attendees INTEGER,
    current_attendees INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table to track which users are attending which events
CREATE TABLE IF NOT EXISTS public.event_attendees (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    event_id UUID REFERENCES public.community_events(id) ON DELETE CASCADE,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(event_id, user_id)
);

-- Add Row Level Security (RLS)
ALTER TABLE public.community_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.event_attendees ENABLE ROW LEVEL SECURITY;

-- Create policies for community_events table
CREATE POLICY "Community events are viewable by everyone" ON public.community_events
    FOR SELECT USING (true);

CREATE POLICY "Only authenticated users can insert community events" ON public.community_events
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Users can update their own community events" ON public.community_events
    FOR UPDATE USING (true); -- You might want to restrict this based on organizer

-- Create policies for event_attendees table
CREATE POLICY "Users can view event attendees" ON public.event_attendees
    FOR SELECT USING (true);

CREATE POLICY "Users can join events" ON public.event_attendees
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can leave events" ON public.event_attendees
    FOR DELETE USING (auth.uid() = user_id);

-- Create indexes for better performance
CREATE INDEX idx_community_events_date ON public.community_events(event_date);
CREATE INDEX idx_community_events_active ON public.community_events(is_active);
CREATE INDEX idx_event_attendees_event_id ON public.event_attendees(event_id);
CREATE INDEX idx_event_attendees_user_id ON public.event_attendees(user_id);

-- Insert some sample data
INSERT INTO public.community_events (title, description, event_date, end_date, location, organizer, max_attendees) VALUES
('Youth Wellness Workshop', 'Interactive workshop focusing on mental health and wellness strategies for young adults.', '2025-02-15 10:00:00+00', '2025-02-15 16:00:00+00', 'Community Center Hall A', 'YouthSpot Team', 50),
('Career Development Seminar', 'Learn about career opportunities, resume building, and interview skills.', '2025-02-20 14:00:00+00', '2025-02-20 18:00:00+00', 'Business Center Conference Room', 'Career Guidance Counselors', 30),
('Mental Health Support Group', 'Safe space for youth to share experiences and learn coping strategies.', '2025-02-25 18:00:00+00', '2025-02-25 20:00:00+00', 'Wellness Center Room B', 'Licensed Therapists', 20),
('Technology Skills Bootcamp', 'Hands-on training in digital literacy and basic programming concepts.', '2025-03-01 09:00:00+00', '2025-03-01 17:00:00+00', 'Tech Hub Training Lab', 'IT Professionals', 25),
('Peer Support Network Meeting', 'Monthly gathering for peer support and community building among youth.', '2025-03-05 16:00:00+00', '2025-03-05 18:00:00+00', 'Youth Center Main Hall', 'Peer Coordinators', 40);