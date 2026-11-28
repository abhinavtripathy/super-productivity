import { EntityState } from '@ngrx/entity';

export interface Note {
  id: string;
  projectId: string | null;
  isPinnedToToday: boolean;
  content: string;
  imgUrl?: string;
  isLock?: boolean;
  backgroundColor?: string;
  // Hidden from the notes panel but kept in its project, so archiving stays a
  // single-entity update. Absent on older data; read as false.
  isArchived?: boolean;
  created: number;
  modified: number;
}

export interface NoteState extends EntityState<Note> {
  ids: string[];
  todayOrder: string[];
}
