-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BENEFICIARIOSINVERCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `BENEFICIARIOSINVERCON`;DELIMITER $$

CREATE PROCEDURE `BENEFICIARIOSINVERCON`(
    Par_InversionID     int,
    Par_BeneInverID     int,
    Par_TipoConsulta          int,

    Aud_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint
	)
TerminaStore: BEGIN


Declare Principal   int;
DECLARE BenefTipoInversion	 char(1);


Set Principal  			 :=  1;
set BenefTipoInversion		:='I';

if(Principal = Par_TipoConsulta)then
    select  Ben.ClienteID,      Ben.Titulo,             Ben.PrimerNombre,   Ben.SegundoNombre,  Ben.TercerNombre,
            Ben.PrimerApellido, Ben.SegundoApellido,    Ben.FechaNacimiento,Ben.PaisID,         Ben.EstadoID,
            Ben.EstadoCivil,    Ben.Sexo,               Ben.CURP,           Ben.RFC,            Ben.OcupacionID,
            Ben.ClavePuestoID,  Ben.TipoIdentiID,       Ben.NumIdentific,   Ben.FecExIden,      Ben.FecVenIden,
            Ben.TelefonoCasa,   Ben.TelefonoCelular,    Ben.Correo,         Ben.Domicilio,      Ben.TipoRelacionID,
            Ben.Porcentaje, 	Inv.Beneficiario
        from BENEFICIARIOSINVER Ben
			INNER JOIN INVERSIONES Inv ON Inv.InversionID =Ben.InversionID
        where Ben.InversionID = Par_InversionID
        and Ben.BenefInverID = Par_BeneInverID;

end if;

END TerminaStore$$