-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GESTORESCOBRANZACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `GESTORESCOBRANZACON`;DELIMITER $$

CREATE PROCEDURE `GESTORESCOBRANZACON`(
	Par_GestorID		INT(11),
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


    DECLARE Con_GestorCob	INT(11);


    SET Con_GestorCob 	:= 1;

	IF(Par_NumCon = Con_GestorCob) THEN
		SELECT		`GestorID`, 			`TipoGestor`, 			`UsuarioID`, 			`Nombre`, 			`ApellidoPaterno`,
					`ApellidoMaterno`, 		`TelefonoParticular`, 	`TelefonoCelular`, 		`EstadoID`, 		`MunicipioID`,
					`LocalidadID`, 			`ColoniaID`, 			`Calle`, 				`NumeroCasa`, 		`NumInterior`,
					`Piso`, 				`PrimeraEntreCalle`, 	`SegundaEntreCalle`, 	`CP`,		 		`PorcentajeComision`,
					`TipoAsigCobranzaID`, 	`Estatus`, 				`FechaRegistro`, 		`FechaActivacion`, 	`FechaBaja`,
					`UsuarioRegistroID`, 	`UsuarioActivaID`, 		`UsuarioBajaID`,		`NombreCompleto`
		FROM GESTORESCOBRANZA
        WHERE GestorID = Par_GestorID   ;
	END IF;


END TerminaStore$$