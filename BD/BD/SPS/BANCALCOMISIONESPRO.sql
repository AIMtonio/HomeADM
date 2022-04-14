-- BANCALCOMISIONESPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `BANCALCOMISIONESPRO`;
DELIMITER $$


CREATE PROCEDURE `BANCALCOMISIONESPRO`(

	Par_ProductoCreditoID	INT(11),
	Par_ClienteID			INT(11),
	Par_MontoSolic			DECIMAL(12,2),

	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),

	Aud_EmpresaID		    INT(11),
    Aud_UsuarioID		    INT(11),
	Aud_FechaActual			DATE,
	Aud_DireccionIP		    VARCHAR(15),
	Aud_ProgramaID		    VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumeroTransaccion	BIGINT(20)
)
TerminaStore : BEGIN


	DECLARE Var_Control					VARCHAR(50);
	DECLARE Var_TipoCobComApert			CHAR(1);
	DECLARE Var_MontoComApert			DECIMAL(12,2);
	DECLARE Var_IVASucursal				DECIMAL(12,2);
	DECLARE Var_ComisionApertura		DECIMAL(12,4);
	DECLARE Var_IvaComApertura			DECIMAL(12,4);


	DECLARE Entero_Cero     			INT(11);
	DECLARE Decimal_Cero    			DECIMAL(12,2);
	DECLARE Cadena_Vacia    			CHAR(1);
	DECLARE Var_TipComPorc				CHAR(1);
	DECLARE Var_TipComMonto				CHAR(1);
	DECLARE SalidaSI        			CHAR(1);


	SET Entero_Cero     				:=  0 ;
	SET Decimal_Cero    				:= 0.0;
	SET Cadena_Vacia    				:= '';
	SET Var_TipComPorc					:= 'P';
	SET Var_TipComMonto					:= 'M';
	SET SalidaSI        				:= 'S';

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
			'esto le ocasiona. Ref: SP-BANCALCOMISIONESPRO');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		 SELECT 	TipoComXapert,	MontoComXapert
			INTO Var_TipoCobComApert, Var_MontoComApert
			FROM PRODUCTOSCREDITO
			WHERE ProducCreditoID = Par_ProductoCreditoID;

		SET Var_TipoCobComApert := IFNULL(Var_TipoCobComApert, Cadena_Vacia);
		SET Var_MontoComApert := IFNULL(Var_MontoComApert, Decimal_Cero);

		IF (Var_TipoCobComApert = Var_TipComPorc) THEN
			SET Var_ComisionApertura := Par_MontoSolic * (Var_MontoComApert / 100);
		END IF;

		IF (Var_TipoCobComApert = Var_TipComMonto) THEN
			SET Var_ComisionApertura := Var_MontoComApert;
		END IF;

		SET Var_MontoComApert := IFNULL(Var_MontoComApert, Decimal_Cero);

		SELECT Suc.IVA
			INTO Var_IVASucursal
			FROM SUCURSALES Suc
			INNER JOIN CLIENTES Cli ON Cli.SucursalOrigen = Suc.SucursalID
			WHERE Cli.ClienteID = Par_ClienteID;

		SET Var_IVASucursal := IFNULL(Var_IVASucursal, Decimal_Cero);

		SET Var_IvaComApertura := Var_ComisionApertura *  Var_IVASucursal;

		SET Var_ComisionApertura 	:= IFNULL(Var_ComisionApertura, Decimal_Cero);
		SET Var_IvaComApertura 		:= IFNULL(Var_IvaComApertura, Decimal_Cero);

		SET Par_NumErr		:= Entero_Cero;
		SET Par_ErrMen		:= 'Comision calculada exitosamente';
		SET Var_Control		:= 'productoCreditoID';

	END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
		SELECT 	Par_NumErr				AS 	NumErr,
				Par_ErrMen				AS	ErrMen,
				Var_ComisionApertura	AS	ComApertura,
				Var_IvaComApertura 		AS	IvaComApertura;
	END IF;


END TerminaStore$$
