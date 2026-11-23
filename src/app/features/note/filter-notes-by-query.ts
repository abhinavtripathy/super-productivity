import { Note } from './note.model';

/**
 * Case-insensitive match where every whitespace-separated term must occur in
 * the note's content, in any order. An empty query matches nothing.
 */
export const filterNotesByQuery = (notes: Note[], query: string): Note[] => {
  const terms = query.toLowerCase().split(/\s+/).filter(Boolean);
  if (!terms.length) {
    return [];
  }
  return notes.filter((note) => {
    const content = (note.content || '').toLowerCase();
    return terms.every((term) => content.includes(term));
  });
};
