-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTACIONSOCIOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTACIONSOCIOCON`;DELIMITER $$

CREATE PROCEDURE `APORTACIONSOCIOCON`(

    Par_ClienteID       INT(11),
    Par_NumCon          TINYINT UNSIGNED,
    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,

    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
    )
TerminaStore: BEGIN


    DECLARE	Con_Principal	INT;
	DECLARE Est_Vigente		CHAR(1);
	DECLARE Est_Vencido		CHAR(1);
	DECLARE Est_Castigo		CHAR(1);
	DECLARE EstInvVigente	CHAR(1);
	DECLARE Entero_Cero		INT(1);
	DECLARE Decimal_Cero	DECIMAL(12,2);
	DECLARE Con_Saldos		INT;


	DECLARE Var_CreditoID		BIGINT(12);
	DECLARE Var_InversionID		INT(11);
	DECLARE Var_CuentaAhoID		BIGINT(12);
	DECLARE Var_MontoAportacion	DECIMAL(12,2);
	DECLARE Var_Saldo			DECIMAL(14,2);

    SET	Con_Principal 	:=	1;
	SET	Est_Vigente		:= 'V';
	SET Est_Vencido		:= 'B';
	SET Est_Castigo		:= 'K';
	SET EstInvVigente	:= 'N';
	SET Entero_Cero		:= 0;
	SET Decimal_Cero	:= 0.0;
	SET Con_Saldos		:=2;

    IF(   Par_NumCon  = Con_Principal) THEN

		SELECT Cre.CreditoID
				FROM CREDITOS Cre
					WHERE Cre.ClienteID = Par_ClienteID
					AND ( Cre.Estatus = Est_Vigente
							OR   Cre.Estatus = Est_Vencido
							OR   Cre.Estatus = Est_Castigo) LIMIT 1 INTO Var_CreditoID;
		SET Var_CreditoID := IFNULL(Var_CreditoID,Entero_Cero);


		SELECT InversionID
				FROM INVERSIONES
				WHERE  ClienteID = Par_ClienteID
				 AND Estatus = EstInvVigente LIMIT 1 INTO Var_InversionID;
		SET Var_InversionID :=IFNULL(Var_InversionID,Entero_Cero);


		SELECT CuentaAhoID
				FROM CUENTASAHO
				WHERE ClienteID=Par_ClienteID
				AND Saldo > Decimal_Cero LIMIT 1 INTO Var_CuentaAhoID;
		SET Var_CuentaAhoID := IFNULL(Var_CuentaAhoID,Entero_Cero);


		SELECT MontoAportacion INTO Var_MontoAportacion
			FROM PARAMETROSSIS;

			SELECT  ClienteID,      FORMAT(IFNULL(Saldo,0),2) AS Saldo ,	SucursalID,       FechaRegistro,      UsuarioID,
					Var_CreditoID AS CreditoID,	Var_InversionID AS InversionID,				IFNULL(Var_CuentaAhoID,0) AS CuentaAhoID, Var_MontoAportacion AS MontoAportacion,
                    FechaCertificado
			FROM APORTACIONSOCIO
			WHERE ClienteID= Par_ClienteID;
    END IF;

    IF(   Par_NumCon  = Con_Saldos) THEN
		SELECT MontoAportacion INTO Var_MontoAportacion
			FROM PARAMETROSSIS LIMIT 1;
		SELECT  FORMAT(IFNULL(Saldo,0),2) AS Saldo INTO Var_Saldo
			FROM APORTACIONSOCIO
			WHERE ClienteID= Par_ClienteID;
		SELECT IFNULL(Var_MontoAportacion,0) AS MontoAportacion, IFNULL(Var_Saldo, 0) AS Saldo;
	END IF;

END TerminaStore$$