-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEIREMESASCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEIREMESASCON`;
DELIMITER $$


CREATE PROCEDURE `SPEIREMESASCON`(

	Par_SpeiRem       		BIGINT(20),
	Par_ClaveRastreo		VARCHAR(30),
    Par_Estatus       		CHAR(1),
    Par_EstatusRem     		INT(3),
    Par_TipoPagoID    		INT(2),

	Par_CuentaAhoID     	BIGINT(12),
	Par_NumCon				TINYINT UNSIGNED,

	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(20),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
)

TerminaStore: BEGIN

	DECLARE	Con_Principal   INT;
	DECLARE Con_CtasRemesas INT;
	DECLARE	Con_TipoPago    INT;
	DECLARE	Con_Verifica	INT;
	DECLARE Con_Autoriza 	INT;
	DECLARE	Status_V		CHAR(1);
	DECLARE Status_A 		CHAR(1);

	SET	Con_Principal	:= 1;
	SET	Con_CtasRemesas	:= 2;
	SET	Con_TipoPago	:= 3;
	SET	Con_Autoriza	:= 4;
	SET Con_Verifica	:= 5;
	SET Status_V        := 'V';
	SET Status_A		:= 'A';

	IF (Par_NumCon = Con_Verifica) THEN

		SELECT SpeiRemID,	ClaveRastreo
		FROM SPEIREMESAS
		WHERE	Estatus	= Status_V;
	END IF;

	IF (Par_NumCon = Con_CtasRemesas) THEN

		SELECT	SR.CuentaAho,	CA.CuentaAhoID,		CA.Estatus AS EstatusCuenta,	CA.SaldoDispon,	TC.Descripcion AS TipoCuenta,
				CL.ClienteID,	CL.NombreCompleto,	CL.estatus AS EstatusCliente,	CL.RazonSocial
		FROM SPEIREMESAS SR
		LEFT JOIN CUENTASAHO CA ON CA.CuentaAhoID = SR.CuentaAho
		LEFT JOIN TIPOSCUENTAS TC ON TC.TipoCuentaID = CA.TipoCuentaID
		LEFT JOIN CLIENTES CL ON CL.ClienteID = CA.ClienteID
		WHERE SR.CuentaAho = Par_CuentaAhoID LIMIT 1;
	END IF;

	IF (Par_NumCon = Con_Autoriza) THEN

		SELECT SpeiRemID,	ClaveRastreo
		FROM SPEIREMESAS
		WHERE	Estatus	= Status_A;
	END IF;

END TerminaStore$$