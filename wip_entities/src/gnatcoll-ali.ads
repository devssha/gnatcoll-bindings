------------------------------------------------------------------------------
--                                  G P S                                   --
--                                                                          --
--                     Copyright (C) 2011-2012, AdaCore                     --
--                                                                          --
-- This is free software;  you can redistribute it  and/or modify it  under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion.  This software is distributed in the hope  that it will be useful, --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public --
-- License for  more details.  You should have  received  a copy of the GNU --
-- General  Public  License  distributed  with  this  software;   see  file --
-- COPYING3.  If not, go to http://www.gnu.org/licenses for a complete copy --
-- of the license.                                                          --
------------------------------------------------------------------------------

--  This package provides support for parsing the .ali and .gli files that
--  are generated by GNAT and gcc. In particular, those files contain
--  information that can be used to do cross-references for entities (going
--  from references to their declaration for instance).
--
--  A typical example would be:
--
--  declare
--     Session : Session_Type;
--  begin
--     GNATCOLL.SQL.Sessions.Setup
--        (Descr   => GNATCOLL.SQL.Sqlite.Setup (":memory:"));
--     Session := Get_New_Session;
--
--     ... parse the project through GNATCOLL.Projects
--
--     Create_Database (Session.DB);
--     Parse_All_LI_Files (Session, ...);
--   end;

with GNATCOLL.Projects;     use GNATCOLL.Projects;
with GNATCOLL.SQL.Exec;     use GNATCOLL.SQL.Exec;
with GNATCOLL.SQL.Sessions; use GNATCOLL.SQL.Sessions;
with GNATCOLL.VFS;

package GNATCOLL.ALI is

   procedure Parse_All_LI_Files
     (Session : Session_Type;
      Tree    : Project_Tree;
      Project : Project_Type;
      Env     : Project_Environment_Access := null;
      Database_Is_Empty : Boolean := False);
   --  Parse all the LI files for the project, and stores them in the
   --  database.
   --  If the caller knows that the database is empty, it should pass True for
   --  Database_Is_Empty. In this case, this package will avoid a number of
   --  calls to SELECT and significantly speed up the initial insertion.
   --  If Env is specified, the ALI files from the predefined object path will
   --  also be parsed.

   procedure Create_Database
     (Connection      : access Database_Connection_Record'Class;
      DB_Schema_Descr : GNATCOLL.VFS.Virtual_File;
      Initial_Data    : GNATCOLL.VFS.Virtual_File);
   --  Create the database tables and initial contents.
   --  Behavior is undefined if the database is not empty initially.
   --  DB_Schema_Descr is the file that contains the description of the
   --  entities database schema.
   --  ??? We should not rely on an external file for this. Perhaps GNATCOLL
   --  could generate some code to create the GNATCOLL.SQL.Inspect.DB_Schema
   --  in the code ?

end GNATCOLL.ALI;
