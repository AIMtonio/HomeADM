-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEPREFAUTOMATICOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `DEPREFAUTOMATICOALT`;

DELIMITER $$
CREATE PROCEDURE `DEPREFAUTOMATICOALT`(
/** SP QUE DA DE ALTA A LA TABLA DEPREFAUTOMATICO DESDE
 ** EL PROCESO DEL KTR PARA DEPOSITOS REFERENCIADOS AUTOMATICOS.*/
	Par_InstitucionID		INT(11),			-- Institucion bancaria
	Par_NumCtaInstit		VARCHAR(20),		-- Numero de cuenta a afectar
	Par_FechaOperacion		DATE,				-- Fecha de la operacion
	Par_ReferenciaMov		VARCHAR(150),		-- Referencia del movimiento cuenta, credito o referencia de pago
	Par_DescripcionMov		VARCHAR(150),		-- Descripcion del movimiento

	Par_NatMovimiento		CHAR(1),			-- Naturaleza del movimiento C-cargo A-Abono
	Par_MontoMov 			DECIMAL(12,2),		-- Monto del movimiento
	Par_MontoPendApli		DECIMAL(12,2),		-- Monto pendiente por aplicar
	Par_TipoCanal			INT(11),			-- Tipo de canal  1 credito 2 cuentaAho
	Par_TipoDeposito		CHAR(3),			-- Tipo de deposito E Efectivo T Tarjeta C Cheque

	Par_Moneda				INT(11),			-- Tipo de moneda defecto 1 valor para moneda mxn
	Par_InsertaTabla		CHAR(1),			-- Indica si se inserta en tabla DEPOSITOREFE S = SI N = NO
	Par_NumIdenArchivo		VARCHAR(20),		-- Numero de identificador del archivo de donde se extrae el dato
	Par_BancoEstandar		CHAR(1),			-- Inidca si el dato viene de Banco estandar (E) o de alguna institucion bancaria(B)
	Par_RutaArchivo			VARCHAR(300),		-- Ruta del archivo al que pertence el registro

	Par_Estatus				CHAR(1),			-- Estatus del registro A=Aplicado  N = No Aplicado
	Par_ConceptoArchivo		VARCHAR(150),		-- Concepto de la referencia.
	Par_Salida				CHAR(1),			-- Indica si se espera una salida
	INOUT Par_NumErr		INT(11),			-- Parametro de salida para el numero de error o exito
	INOUT Par_ErrMen		VARCHAR(400),		-- Parametro de salida para el mensaje de error o exito

	Aud_EmpresaID			INT(11),			-- Parametro de auditoria
	Aud_Usuario				INT(11),			-- Parametro de auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria

	Aud_Sucursal			INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria
)
TerminaStore:BEGIN
	-- Declaracion de variables
	DECLARE Var_NombreArchivo	VARCHAR(80);	-- Nombre del archivo en la BD
	DECLARE Var_Control			VARCHAR(50);	-- Variable de control
	DECLARE Var_ConsecutivoID	BIGINT(12);	-- Variable para el valor consecutivo generado
	DECLARE Var_NatMovimiento	CHAR(1);		-- Variable para la naturaleza del deposito
	DECLARE Var_TipoDeposito	CHAR(1);		-- Variable para el tipo de deposito

	-- Declaracion de constantes
	DECLARE	Entero_Cero 	INT(11); 		-- Constante Entero Cero
	DECLARE Decimal_Cero	DECIMAL(12,2);	-- Constante DECIMAL Cero
	DECLARE Entero_Uno		INT(11);		-- Constante Entero Uno
	DECLARE Entero_Dos		INT(11);		-- Constante Entero Dos
	DECLARE Cadena_Vacia	CHAR(1);		-- Constante Cadena Vacia
	DECLARE Fecha_Vacia		DATE;			-- Constante Fecha Vacia
	DECLARE SalidaSI		CHAR(1);		-- Constante Salida SI

	-- Seteo de valores
	SET Entero_Cero		:= 0;
	SET Decimal_Cero 	:= 0.00;
	SET Entero_Uno		:= 1;
	SET Entero_Dos		:= 2;
	SET Cadena_Vacia	:= '';
	SET Fecha_Vacia		:= '1900-01-01';
	SET SalidaSI		:= 'S';
	SET Aud_FechaActual := NOW();

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
							'Disculpe las molestias que esto le ocaciones. Ref: SP-DEPREFAUTOMATICOALT');
			SET Var_Control	:='SQLEXCEPTION';
		END;

		IF IFNULL(Par_InstitucionID,Entero_Cero) = Entero_Cero THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'El numero de institucion esta vacio';
			SET Var_Control:= 'institucionID';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_NumCtaInstit,Cadena_Vacia) = Cadena_Vacia THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'El numero de cuenta esta vacio';
			SET Var_Control:= 'numCtaInstit';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_FechaOperacion,Fecha_Vacia) = Fecha_Vacia THEN
			SET Par_NumErr := 3;
			SET Par_ErrMen := 'La fecha de operacion esta vacia';
			SET Var_Control:= 'fechaOperacion';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_ReferenciaMov,Cadena_Vacia) = Cadena_Vacia THEN
			SET Par_NumErr := 4;
			SET Par_ErrMen := 'La referencia del movimiento esta vacia';
			SET Var_Control:= 'referenciaMov';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_DescripcionMov,Cadena_Vacia) = Cadena_Vacia THEN
			SET Par_NumErr := 5;
			SET Par_ErrMen := 'La descripcion del movimiento esta vacia';
			SET Var_Control:= 'descripcionMov';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_NatMovimiento,Cadena_Vacia) = Cadena_Vacia THEN
			SET Par_NumErr := 6;
			SET Par_ErrMen := 'La naturaleza del movimiento esta vacia';
			SET Var_Control:= 'natMovimiento';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_MontoMov,Decimal_Cero) = Decimal_Cero THEN
			SET Par_NumErr := 7;
			SET Par_ErrMen := 'El monto del movimiento esta Vacio';
			SET Var_Control:= 'montoMov';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_TipoCanal,Entero_Cero) = Entero_Cero THEN
			SET Par_NumErr := 8;
			SET Par_ErrMen := 'El tipo de canal esta vacio';
			SET Var_Control:= 'tipoCanal';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_TipoDeposito,Cadena_Vacia) = Cadena_Vacia THEN
			SET Par_NumErr := 9;
			SET Par_ErrMen := 'El tipo de deposito esta vacio';
			SET Var_Control:= 'tipoDeposito';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_InsertaTabla,Cadena_Vacia) = Cadena_Vacia THEN
			SET Par_NumErr := 10;
			SET Par_ErrMen := 'No se a indicado si se inserta en tabla';
			SET Var_Control:= 'insertaTabla';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_NumIdenArchivo,Cadena_Vacia) = Cadena_Vacia THEN
			SET Par_NumErr := 11;
			SET Par_ErrMen := 'El numero de identificador de archivo esta vacio';
			SET Var_Control:= 'numIdenArchivo';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_BancoEstandar,Cadena_Vacia) = Cadena_Vacia THEN
			SET Par_NumErr := 12;
			SET Par_ErrMen := 'No se indico el tipo de banco';
			SET Var_Control:= 'bancoEstandar';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_ConceptoArchivo,Cadena_Vacia) = Cadena_Vacia THEN
			SET Par_NumErr := 13;
			SET Par_ErrMen := 'El concepto del movimiento esta vacio';
			SET Var_Control:= 'concepto';
			LEAVE ManejoErrores;
		END IF;

		SET Var_ConsecutivoID := (SELECT IFNULL(MAX(ConsecutivoID),Entero_Cero)+1 FROM DEPREFAUTOMATICO);

		IF Par_NatMovimiento = "1" THEN
			SET Var_NatMovimiento := "C";
		END IF;

		IF Par_NatMovimiento = "0" THEN
			SET Var_NatMovimiento := "A";
		END IF;

		-- Obtenemos el tipo de depopsito segun el codigo de leyenda bancomer
		CALL CATCODLEYENDACON(
			Par_TipoDeposito,	Cadena_Vacia,		Entero_Uno,			Var_TipoDeposito,	Aud_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);


		INSERT INTO DEPREFAUTOMATICO (
			ConsecutivoID,		InstitucionID,		NumCtaInstit,		FechaOperacion,		ReferenciaMov,
			DescripcionMov,		NatMovimiento,		MontoMov,			MontoPendApli,		TipoCanal,
			TipoDeposito,		Moneda,				InsertaTabla,		NumIdenArchivo,		BancoEstandar,
			RutaArchivo,		FechaCarga,			Estatus,			ConceptoArchivo,	EmpresaID,
			Usuario,			FechaActual,		DireccionIP,		ProgramaID,			Sucursal,
			NumTransaccion)
		VALUES (
			Var_ConsecutivoID,	Par_InstitucionID, 	Par_NumCtaInstit, 	Par_FechaOperacion, Par_ReferenciaMov,
			Par_DescripcionMov,	Var_NatMovimiento, 	Par_MontoMov, 		Par_MontoPendApli, 	Par_TipoCanal,
			Var_TipoDeposito, 	Par_Moneda, 		Par_InsertaTabla, 	Par_NumIdenArchivo, Par_BancoEstandar,
			Par_RutaArchivo,	NOW(),				Par_Estatus, 		Par_ConceptoArchivo,Aud_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID, 	Aud_Sucursal,
			Aud_NumTransaccion);

		SET Par_NumErr :=0;
		SET Par_ErrMen := 'Registro Agregado Correctamente.';
		SET Var_Control := Cadena_Vacia;

	END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr		AS NumErr,
				Par_ErrMen		AS ErrMen,
				Var_Control		AS Control,
				Var_ConsecutivoID	AS Consecutivo;
	END IF;

END TerminaStore$$