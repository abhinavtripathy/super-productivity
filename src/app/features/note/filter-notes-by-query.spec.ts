import { filterNotesByQuery } from './filter-notes-by-query';
import { Note } from './note.model';

const note = (id: string, content: string, isArchived?: boolean): Note => ({
  id,
  content,
  projectId: null,
  isPinnedToToday: false,
  created: 0,
  modified: 0,
  ...(isArchived !== undefined ? { isArchived } : {}),
});

describe('filterNotesByQuery', () => {
  const notes = [
    note('a', 'Grocery list: milk, eggs'),
    note('b', '# Meeting\nDiscuss the Roadmap', true),
    note('c', 'Roadmap draft for Q3'),
  ];

  it('returns nothing for an empty or whitespace query', () => {
    expect(filterNotesByQuery(notes, '')).toEqual([]);
    expect(filterNotesByQuery(notes, '   ')).toEqual([]);
  });

  it('matches case-insensitively', () => {
    expect(filterNotesByQuery(notes, 'MILK').map((n) => n.id)).toEqual(['a']);
  });

  it('includes archived notes', () => {
    expect(filterNotesByQuery(notes, 'roadmap').map((n) => n.id)).toEqual(['b', 'c']);
  });

  it('requires every term, in any order', () => {
    expect(filterNotesByQuery(notes, 'q3 roadmap').map((n) => n.id)).toEqual(['c']);
    expect(filterNotesByQuery(notes, 'roadmap milk')).toEqual([]);
  });

  it('treats missing content as empty', () => {
    const broken = { ...note('d', ''), content: undefined as unknown as string };
    expect(filterNotesByQuery([broken], 'x')).toEqual([]);
  });
});
