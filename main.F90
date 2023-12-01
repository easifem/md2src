!> authors: Vikas Sharma, Ph. D.
! date: 2021-11-07
! update: 2021-11-07
! summary: This code reads a markdown file and extracts the fortran code

PROGRAM main
USE easifemBase
USE easifemClasses
IMPLICIT NONE
TYPE(TxtFile_) :: srcfile, mdfile
INTEGER(I4B), PARAMETER :: maxStrLen = 1024
CHARACTER(LEN=maxStrLen) :: mdfilename
CHARACTER(LEN=maxStrLen) :: srcfilename
CHARACTER(LEN=*), PARAMETER :: modname = "md2src"
CHARACTER(LEN=*), PARAMETER :: myname = "main"
TYPE(CommandLineInterface_) :: cli
INTEGER(I4B) :: error
!> main
! initializing Command Line Interface
CALL cli%initiate( &
     & progname='md2src', &
     & version='v23.1.0', &
     & authors='Vikas Sharma, Ph.D.', &
     & license='MIT', &
     & description='Extract code from the markdown file and create a source file.',&
     & examples=[ &
     & 'md2src                                           ', &
     & 'md2src -h                                        ', &
     & 'md2src --input inputFile.md --output outFile.F90 ', &
     & 'md2src -i inputFile.md -o outFile.F90            ', &
     & 'md2src --version                                 ', &
     & 'md2src -v                                        '])
CALL cli%add(switch='--input',switch_ab='-i',help='name of input markdown file',&
     & required=.TRUE., act='store', error=error)
IF (error .NE. 0) &
     & CALL e%raiseError(modName//"::"//myName//" - "// &
     & 'cannot add value of --input from CLI')
!> handling output
CALL cli%add(switch='--output',switch_ab='-o',help='name of output source file',&
     & required=.FALSE., act='store', def='default', error=error)
IF (error .NE. 0) &
     & CALL e%raiseError(modName//"::"//myName//" - "// &
     & 'cannot add value of --output from CLI')
CALL cli%get(switch='-i', val=mdfilename, error=error)
IF (error .NE. 0) &
     & CALL e%raiseError(modName//"::"//myName//" - "// &
     & 'cannot get value of --input from CLI')
CALL e%raiseInformation(modName//"::"//myName//" - "// &
     & 'Parsing markdown file : '//TRIM(mdfilename))
CALL mdfile%Initiate(filename=mdfilename, STATUS="OLD", ACTION="READ")
CALL mdfile%OPEN()
CALL cli%get(switch='-o', val=srcfilename, error=error)
IF (error .NE. 0) &
     & CALL e%raiseError(modName//"::"//myName//" - "// &
     & 'cannot get value of --output from CLI')
IF (TRIM(srcfilename) .EQ. 'default') THEN
  srcfilename = TRIM(mdfile%getFilePath())//TRIM(mdfile%getFileName())//".F90"
END IF
CALL e%raiseInformation(modName//"::"//myName//" - "// &
& 'Results will be written to file : '//TRIM(srcfilename))
CALL srcfile%Initiate(filename=srcfilename, status="REPLACE", &
    & ACTION="WRITE")
CALL srcfile%OPEN()
CALL mdfile%ConvertMarkdownToSource(outfile=srcfile)
CALL mdfile%DEALLOCATE()
CALL srcfile%DEALLOCATE()
END PROGRAM main
