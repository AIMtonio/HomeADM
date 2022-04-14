-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECASTIGOSVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRECASTIGOSVAL`;
DELIMITER $$


CREATE PROCEDURE `CRECASTIGOSVAL`(

	Par_CreditoID			BIGINT,

    Par_Salida        		CHAR(1),
	OUT Par_NumErr 			INT(11),
	OUT	Par_ErrMen			VARCHAR(400),

	Par_EmpresaID     		INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion 		BIGINT
	)

TerminaStore: BEGIN



	DECLARE Var_ClienteID 	INT(11);


	DECLARE Decimal_Cero	DECIMAL(12,2);
	DECLARE Entero_Cero		INT(4);
	DECLARE SalidaSI		CHAR(1);
	DECLARE Inv_Vigente		CHAR(1);
	DECLARE Cue_Activa		CHAR(1);
	DECLARE Nat_Bloqueado	CHAR(1);



	SET Decimal_Cero	:= 0.0;
	SET Entero_Cero		:= 0;
	SET SalidaSI		:= 'S';
	SET Inv_Vigente		:= 'N';
	SET Cue_Activa		:= 'A';
	SET Nat_Bloqueado	:= 'B';



	SET Par_NumErr		:= 0;
	SET Par_ErrMen		:= 'El safilocale.cliente Tiene: <br> ';

	SELECT ClienteID		INTO
		   Var_ClienteID
	FROM CREDITOS
	WHERE CreditoID = Par_CreditoID;


	Validaciones: BEGIN

		IF EXISTS (SELECT InversionID FROM INVERSIONES WHERE ClienteID = Var_ClienteID AND Estatus = Inv_Vigente)THEN
			SET Par_NumErr 	:= 1;
			SET Par_ErrMen 	:= CONCAT(Par_ErrMen, 'Inversion(es) Vigente(s). <br>');
		END IF;

		IF EXISTS (SELECT CuentaAhoID FROM CUENTASAHO WHERE ClienteID = Var_ClienteID AND Estatus = Cue_Activa AND Saldo > Decimal_Cero)THEN
			SET Par_NumErr 	:= 2;
			SET Par_ErrMen 	:= CONCAT(Par_ErrMen, 'Cuenta(s) Con Saldo a Favor. <br>');
		END IF;

		IF EXISTS (SELECT CreditoInvGarID FROM CREDITOINVGAR WHERE CreditoID = Par_CreditoID)THEN
			SET Par_NumErr 	:= 3;
			SET Par_ErrMen 	:= CONCAT(Par_ErrMen, 'Inversion(es) en Garantia Liquida. <br>');
		END IF;

		IF EXISTS (SELECT BloqueoID FROM BLOQUEOS WHERE Referencia = Par_CreditoID AND NatMovimiento = Nat_Bloqueado AND FolioBloq = Entero_Cero)THEN
			SET Par_NumErr 	:= 4;
			SET Par_ErrMen 	:= CONCAT(Par_ErrMen, 'Bloqueo de Saldo en Garantia Liquida.');
		END IF;


	 END Validaciones;

	IF (Par_Salida = SalidaSI) THEN
		SELECT Par_NumErr 		AS NumErr,
			   Par_ErrMen 		AS ErrMen,
			   'creditoID' 		AS control,
			   Par_CreditoID 	AS consecutivo;
	END IF;

END TerminaStore$$