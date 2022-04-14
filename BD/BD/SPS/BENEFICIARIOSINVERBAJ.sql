-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BENEFICIARIOSINVERBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `BENEFICIARIOSINVERBAJ`;DELIMITER $$

CREATE PROCEDURE `BENEFICIARIOSINVERBAJ`(
	Par_InversionID		int(11),
	Par_BenefInverID	int(11),

	Par_Salida			char(1),
	inout Par_NumErr	int,
	inout Par_ErrMen	varchar(400),

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,

	Aud_NumTransaccion	bigint	)
TerminaStore: BEGIN

DECLARE varControl varchar(50);


DECLARE	Salida_Si		char(1);
DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;


Set	Salida_Si		:= 'S';
Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;



ManejoErrores:BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr = '999';
                SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
										 'estamos trabajando para resolverla. Disculpe las molestias que ',
										 'esto le ocasiona. Ref: SP-BENEFICIARIOSINVERBAJ');
                SET varControl = 'sqlException' ;
            END;

IF(ifnull(Par_InversionID,Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr  := '001';
            SET Par_ErrMen  := 'El numero de inversion esta vacio.';
            SET varControl  := 'inversionID' ;
            LEAVE ManejoErrores;
        END IF;

IF(ifnull(Par_BenefInverID,Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr  := '002';
            SET Par_ErrMen  := 'El beneficiario esta vacio.';
            SET varControl  := 'beneInverID' ;
            LEAVE ManejoErrores;
        END IF;

	delete from BENEFICIARIOSINVER
	where InversionID = Par_InversionID
	and	BenefInverID = Par_BenefInverID;

			SET Par_NumErr  :='000';
            SET Par_ErrMen  := concat('Beneficiario Eliminado Exitosamente: ' , Par_BenefInverID);
            SET varControl  := 'beneInverID';
END ManejoErrores;

        IF (Par_Salida = Salida_SI) THEN
            SELECT  convert(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen			 AS ErrMen,
            varControl			 AS control,
            Par_BenefInverID	    AS consecutivo;
        end IF;

END TerminaStore$$