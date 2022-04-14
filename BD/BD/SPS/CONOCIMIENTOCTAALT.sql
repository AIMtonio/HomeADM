-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONOCIMIENTOCTAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONOCIMIENTOCTAALT`;
DELIMITER $$


CREATE PROCEDURE `CONOCIMIENTOCTAALT`(
	/* SP PARA ALTA DE CONOCIMIENTO DE CUENTA */
	Par_CuentaAhoID 		BIGINT(12),
	Par_DepositoCred		DECIMAL(12,2),
	Par_RetirosCargo		DECIMAL(12,2),
	Par_ProcRecursos		VARCHAR(80) ,
	Par_ConcentFondo		CHAR(1),

	Par_AdmonGtosIng		CHAR(1),
	Par_PagoNomina			CHAR(1),
	Par_CtaInversion		CHAR(1),
	Par_PagoCreditos		CHAR(1),
	Par_OtroUso				CHAR(1),

	Par_DefineUso			VARCHAR(80),
	Par_RecursoProv			CHAR(1),
	Par_RecursoProvT		CHAR(1),
	Par_NumDep				INT(11),
	Par_FrecDep				INT(11),

	Par_NumRet				INT(11),
	Par_FrecRet				INT(11),
	Par_MediosElectronicos	CHAR(1),
	Par_Salida				CHAR(1),
	INOUT	Par_NumErr		INT(11),
	INOUT	Par_ErrMen		VARCHAR(400),

	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),

	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
		)

TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_EsHabil			CHAR(1);
	DECLARE Var_Control			VARCHAR(50);
	DECLARE	Var_Consecutivo		BIGINT;

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia						CHAR(1);
	DECLARE	Entero_Cero							INT;
	DECLARE	Decimal_Cero						DECIMAL(12,4);
	DECLARE Var_SI 								CHAR(1);
	DECLARE Var_NO 								CHAR(1);

	DECLARE Var_Propios 						CHAR(1);
	DECLARE Var_Terceros 						CHAR(1);
	DECLARE MenorEdad							CHAR(1);
	DECLARE Var_CuentaID						BIGINT(12);
	DECLARE Alta_ConocimientoCTA				INT(11);						# Alta de Conocimiento de la Cta

	-- Asignacion de constantes
	SET	Cadena_Vacia				:= '';			-- Cadena Vacia
	SET	Entero_Cero					:= 0;			-- Entero Cero
	SET	Decimal_Cero				:= 0.0;			-- Decimal Cero
	SET	Var_SI						:= 'S';			-- Variable Si
	SET Var_NO						:= 'N';			-- Variable No
	SET Var_Propios					:= 'P';			-- Recursos Propios
	SET Var_Terceros				:= 'T';			-- Recursos Terceros
	SET MenorEdad					:= 'S';
	SET Alta_ConocimientoCTA 		:= 6;			# Alta de Conocimiento de la Cuenta



	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								  'Disculpe las molestias que esto le ocasiona. Ref: SP-CONOCIMIENTOCTAALT');
			SET Var_Control := 'SQLEXCEPTION';
		END;

		SET Var_CuentaID:= (SELECT CuentaAhoID FROM CUENTASAHO WHERE CuentaAhoID = IFNULL(Par_CuentaAhoID,Entero_Cero));

		IF(IFNULL(Par_CuentaAhoID, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr      := 1;
			SET Par_ErrMen      := 'El numero de Cuenta esta Vacio.';
			SET Var_Control		:= 'cuentaAhoID';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Var_CuentaID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr		:=	20;
			SET Par_ErrMen		:=	'El numero de Cuenta no existe';
			SET Var_Control		:=	'cuentasAhoID';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE	ManejoErrores;
		END IF;

		IF(IFNULL(Par_DepositoCred, Decimal_Cero))= Decimal_Cero THEN
			SET Par_NumErr		:=	2;
			SET	Par_ErrMen		:=	'La Cantidad de Depositos esta Vacia.';
			SET Var_Control		:=	'depositoCred';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE	ManejoErrores;
		END IF;

		IF(IFNULL(Par_RetirosCargo, Decimal_Cero))= Decimal_Cero THEN
			SET	Par_NumErr		:=	3;
			SET Par_ErrMen		:=	'La Cantidad de Retiros esta Vacia.';
			SET Var_Control		:=	'retirosCargo';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE	ManejoErrores;
		END IF;

		IF(IFNULL(Par_ProcRecursos,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr		:=	4;
			SET Par_ErrMen		:=	'La Procedencia de los recursos esta Vacia.';
			SET Var_Control		:=	'procRecursos';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE	ManejoErrores;
		END IF;

		IF(IFNULL(Par_OtroUso,Cadena_Vacia)) = Var_SI THEN
			IF(IFNULL(Par_DefineUso,Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr	:=	6;
				SET	Par_ErrMen	:=	'Definir Otro Uso de los Recursos';
				SET	Var_Control	:=	'defineUso';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_ConcentFondo,Cadena_Vacia)) != Cadena_Vacia THEN
			IF(Par_ConcentFondo != Var_SI
				AND Par_ConcentFondo != Var_NO) THEN
				SET	Par_NumErr	:= 7;
				SET	Par_ErrMen	:= 'Valor invalido para Concentracion de Fondos.';
				SET Var_Control	:= 'concentFondo';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_AdmonGtosIng,Cadena_Vacia)) != Cadena_Vacia THEN
			IF(Par_AdmonGtosIng != Var_SI
				AND Par_AdmonGtosIng != Var_NO) THEN
				SET	Par_NumErr	:= 8;
				SET	Par_ErrMen	:= 'Valor invalido para Admon de Gtos e Ingresos.';
				SET Var_Control := 'admonGtosIng';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_PagoNomina,Cadena_Vacia)) != Cadena_Vacia THEN
			IF(Par_PagoNomina != Var_SI
				AND Par_PagoNomina != Var_NO) THEN
					SET	Par_NumErr	:= 9;
					SET Par_ErrMen 	:= 'Valor invalido para Pago de Nomina.';
					SET Var_Control :=	'pagoNomina';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_CtaInversion,Cadena_Vacia)) != Cadena_Vacia THEN
			IF(Par_CtaInversion != Var_SI
				AND Par_CtaInversion != Var_NO) THEN
					SET Par_NumErr	:= 10;
					SET	Par_ErrMen	:= 'Valor invalido para Cta de Inversion.';
					SET Var_Control	:= 'ctaInversion';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_PagoCreditos,Cadena_Vacia)) != Cadena_Vacia THEN
			IF(Par_PagoCreditos != Var_SI
				AND Par_PagoCreditos != Var_NO) THEN
					SET Par_NumErr	:=	11;
					SET	Par_ErrMen	:=	'Valor invalido para Pagos de Credito.';
					SET Var_Control	:=	'pagoCreditos';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_OtroUso,Cadena_Vacia)) != Cadena_Vacia THEN
			IF(Par_OtroUso != Var_SI
				AND Par_OtroUso != Var_NO) THEN
					SET	Par_NumErr	:= 12;
					SET Par_ErrMen	:= 'Valor invalido para Otro Uso.';
					SET	Var_Control	:=	'otroUso';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_RecursoProv, Cadena_Vacia) = Cadena_Vacia ) AND (IFNULL(Par_RecursoProvT, Cadena_Vacia) = Cadena_Vacia ) THEN
				SET	Par_NumErr	:=	13;
				SET Par_ErrMen	:=	'Seleccione opcion para Procedencia de los Recursos a Manejar.';
				SET Var_Control	:=	'recursoProv';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
		ELSE
			IF(IFNULL(Par_RecursoProv, Cadena_Vacia) != Cadena_Vacia ) THEN
				IF(Par_RecursoProv != Var_Propios) THEN
					SET	Par_NumErr	:=	14;
					SET Par_ErrMen	:=	'Valor invalido para Procedencia de los Recursos a Manejar.' ;
					SET	Var_Control	:=	'recursoProv';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;
			END IF;
			IF(IFNULL(Par_RecursoProvT, Cadena_Vacia) != Cadena_Vacia ) THEN
				IF(Par_RecursoProvT != Var_Terceros) THEN
					SET Par_NumErr	:=	15;
					SET Par_ErrMen	:=	'Valor invalido para Procedencia de los Recursos a Manejar.';
					SET	Var_Control	:=	'recursoProvT';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		IF(IFNULL(Par_NumDep, Entero_Cero))= Entero_Cero THEN
			SET	Par_NumErr	:=	16;
			SET	Par_ErrMen	:=	'El Numero de Depositos esta Vacio.';
			SET	Var_Control	:=	'cuentaAhoID';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FrecDep, Entero_Cero))= Entero_Cero THEN
			SET	Par_NumErr	:=	17;
			SET Par_ErrMen	:=	'La Frecuencia de Depositos esta Vacia.';
			SET	Var_Control	:=	'cuentaAhoID';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_NumRet, Entero_Cero))= Entero_Cero THEN
			SET	Par_NumErr	:=	18;
			SET	Par_ErrMen	:=	'El Numero de Retiros esta Vacio.';
			SET	Var_Control	:=	'cuentaAhoID';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FrecRet, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr	:=	19;
			SET	Par_ErrMen	:=	'La Frecuencia de Retiros esta Vacia.';
			SET	Var_Control	:=	'cuentaAhoID';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := NOW();

		INSERT INTO CONOCIMIENTOCTA	(
			CuentaAhoID, 		DepositoCred, 		RetirosCargo, 		ProcRecursos, 		ConcentFondo,
			AdmonGtosIng, 		PagoNomina, 		CtaInversion, 		PagoCreditos, 		OtroUso,
			DefineUso, 			RecursoProvProp, 	RecursoProvTer, 	NumDepositos, 		FrecDepositos,
			NumDepoApli,		NumRetiros, 		FrecRetiros, 		NumRetiApli,		MediosElectronicos,
			EmpresaID, 			Usuario,	 		FechaActual, 		DireccionIP, 		ProgramaID,
			Sucursal,			NumTransaccion)
		VALUES (
			Par_CuentaAhoID,	Par_DepositoCred,	Par_RetirosCargo,	Par_ProcRecursos,	Par_ConcentFondo,
			Par_AdmonGtosIng,	Par_PagoNomina,		Par_CtaInversion,	Par_PagoCreditos,	Par_OtroUso,
			Par_DefineUso,		Par_RecursoProv,	Par_RecursoProvT, 	Par_NumDep,			Par_FrecDep,
			Entero_Cero,		Par_NumRet,			Par_FrecRet,  		Entero_Cero,		Par_MediosElectronicos,
			Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);

		/*Se almacena la Informacion en la Bitacora Historica. ############################################################################ */
		CALL BITACORAHISTPERSALT(
			Aud_NumTransaccion,			Alta_ConocimientoCTA,	Entero_Cero,				Par_CuentaAhoID,		Entero_Cero,
			Entero_Cero,				Var_NO,					Par_NumErr,					Par_ErrMen,				Aud_EmpresaID,
			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr!=Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
		/*FIN de Respaldo de Bitacora Historica ########################################################################################### */
		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:=  CONCAT("Conocimiento de Cuenta Agregado: ", CONVERT(Par_CuentaAhoID, CHAR));
	END ManejoErrores;

	IF (Par_Salida = Var_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
		Par_ErrMen AS ErrMen,
		Var_Control AS control,
		Par_CuentaAhoID AS consecutivo;
	END IF;

END TerminaStore$$