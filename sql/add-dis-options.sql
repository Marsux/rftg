/*
 * Starting from version 0.9.6, the way the disabled option flags are stored
 * has changed. In the table games, the two fields dis_goal and dis_takeover are
 * not used anymore, a new field, dis_options, is introduced and contains in a
 * packed form the flags. This script enables to migrate an existing rftg
 * database to the new format.
 */

-- Select the database
USE rftg;

-- Add the new column
ALTER TABLE games ADD COLUMN dis_options INT NOT NULL AFTER dis_takeover;

-- Compute the dis_options field from dis_goal and dis_takeover fields
UPDATE games SET dis_options = dis_goal + 2*dis_takeover;
