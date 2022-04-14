-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COBCARTERAASIGCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `COBCARTERAASIGCON`;DELIMITER $$

CREATE PROCEDURE `COBCARTERAASIGCON`(
	Par_FolioAsigID		INT(11),
    Par_NumCon			TINYINT UNSIGNED,

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN


    DECLARE Con_AsigCartera	INT(11);


    SET Con_AsigCartera 	:= 1;

	IF(Par_NumCon = Con_AsigCartera) THEN

		SELECT
		`FolioAsigID`,			`FechaAsig`,			`GestorID`,				`PorcentajeComision`,	  	`TipoAsigCobranzaID`,
		`EstatusAsig`,			`FechaBaja`,			`UsuarioAsigID`,		`UsuarioLibeID`,			`DiaAtrasoMin`,
		`DiaAtrasoMax`, 		`AdeudoMin`, 			`AdeudoMax`, 			`EstCredito`, 				`SucursalID`,
        `EstadoID`, 			`MunicipioID`, 			`LocalidadID`, 			`ColoniaID`, 				`LimRenglones`
        FROM    COBCARTERAASIG
        WHERE FolioAsigID = Par_FolioAsigID   ;
	END IF;


END TerminaStore$$