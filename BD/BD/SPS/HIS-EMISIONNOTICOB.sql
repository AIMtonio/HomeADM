-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-EMISIONNOTICOB
DELIMITER ;
DROP PROCEDURE IF EXISTS `HIS-EMISIONNOTICOB`;DELIMITER $$

CREATE PROCEDURE `HIS-EMISIONNOTICOB`(
	Par_FechaOperacion 	DATE,

    Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),

	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN


    DECLARE Var_FechaSis	VARCHAR(10);


    SET Var_FechaSis = (SELECT FechaSistema FROM PARAMETROSSIS WHERE EmpresaID=1);


    INSERT INTO `HISEMISIONNOTICOB`(
		`FechaSistema`,		`CreditoID`, 		`FechaEmision`, 	`UsuarioID`, 		`ClaveUsuario`,
        `SucursalUsuID`, 	`FormatoID`, 		`FechaCita`, 		`HoraCita`, 		`EmpresaID`,
		`Usuario`,          `FechaActual`,		`DireccionIP`, 		`ProgramaID`, 		`Sucursal`,
		`NumTransaccion`
    )
    SELECT
		Var_FechaSis,		`CreditoID`, 		`FechaEmision`, 	`UsuarioID`, 		`ClaveUsuario`,
        `SucursalUsuID`, 	`FormatoID`, 		`FechaCita`, 		`HoraCita`, 		`EmpresaID`,
		`Usuario`,          `FechaActual`,		`DireccionIP`, 		`ProgramaID`, 		`Sucursal`,
		`NumTransaccion`
	FROM EMISIONNOTICOB;

    DELETE FROM EMISIONNOTICOB;

END TerminaStore$$