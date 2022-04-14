-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARCHIVOCARGADEPREFALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARCHIVOCARGADEPREFALT`;
DELIMITER $$

CREATE PROCEDURE `ARCHIVOCARGADEPREFALT`(
	/* ALTA DEL ARCHIVO DE CARGA PARA DEPÓSITOS REFERENCIADOS. */
	Par_InstitucionID		INT(11),			-- ID DE LA INSTITUCIÓN BANCARIA.
	Par_NumCtaInstit		VARCHAR(20),		-- NÚMERO DE CTA DE LA INST. BANCARIA.
	Par_FechaOperacion		DATE,				-- FECHA DE OPERACIÓN.
	Par_ReferenciaMov		VARCHAR(150),		-- REFERENCIA DELMOVIMIENTO.
	Par_DescripcionMov		VARCHAR(150),		-- DESCRIPCIÓN DEL MOVIMIENTO.

	Par_NatMovimiento		CHAR(1),			-- NATURALEZA DEL MOVIMIENTO. C.- CARGO A.- ABONO.
	Par_MontoMov 			DECIMAL(12,2),		-- MONTO DEL MOVIMIENTO.
	Par_MontoPendApli		DECIMAL(12,2),		-- MONTO PENDIENTE POR APLICAR.
	Par_TipoCanal			INT(11),			-- TIPO DE CANAL (TIPOCANAL).
	Par_NumIdenArchivo		VARCHAR(20),		-- NUMERO DE TRANSACCION DEL ARCHIVO Y CON LA FECHA EN QUE SE REALIZA LA OPERACION.

	Par_TipoDeposito		CHAR(1),			-- TIPO DE DEPÓSITO. E.-  SI PAGO EFECTIVO T.-  OTRO TIPO DEPOSITO.
    Par_Validacion			VARCHAR(150),
	Par_Moneda				INT(11),			-- Número de la Moneda. MONEDAS.
	Par_InsertaTabla		CHAR(1),			-- S.- SI INSERTA N.- NO INSERTA.
	Par_TranAnt				BIGINT(20),			-- NÚMERO DE TRANSACCIÓN ANTERIOR.

	Par_NumVal				INT(11),			-- NÚMERO DE VALIDACION.
	Par_TipoMov				CHAR(2),			-- TIPO DE MOVIMIENTO.
	Par_NumeroFila 			INT(11),			-- Numero de Fila del deposito en el archivo cargado
	Par_AplicarDeposito 	CHAR(1),			-- En la pantalla de Depositos se selecciono para aplicar el deposito S= si, N = no
	Par_NombreArchivoCarga 	VARCHAR(500),		-- Nombre del archivo donde se cargo el deposito

    Par_Salida				CHAR(1),			-- TIPO DE SALIDA.
	INOUT Par_NumErr		INT(11),			-- NÚMERO DE ERROR.
	INOUT Par_ErrMen		VARCHAR(400),		-- MENSAJE DE EERROR

	INOUT Par_Consecutivo	BIGINT(20),			-- NÚMERO CONSECUTIVO.
	/* Parámetros de Auditoría */
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),

	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE	Var_FolioOperacion		INT;
	DECLARE Var_Control				VARCHAR(50);
	DECLARE Var_CuentaBancaria		VARCHAR(20);
	DECLARE Var_Estatus				CHAR(2);
	DECLARE Var_SiInserta			CHAR(1);
	DECLARE Var_NumTran				BIGINT(20);
	DECLARE Var_NumIdenRep			INT(11);
	DECLARE Var_DepRefMesAnterior	CHAR(1);
	DECLARE Var_FechaSisIni			DATE;

	-- Declaracion de Constantes
	DECLARE Entero_Cero 		INT;
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Decimal_Cero		DECIMAL(12,2);
	DECLARE Var_FechaSistema	DATE;
	DECLARE TipoMovDepRef		CHAR(1);
	DECLARE Salida_SI			CHAR(1);
	DECLARE Salida_NO			CHAR(1);
	DECLARE Cons_Cero			CHAR(1);

	-- Asignacion de Constantes
	SET Entero_Cero		:= 0;
	SET Decimal_Cero	:= 0;
	SET TipoMovDepRef	:= '1';
	SET Salida_SI		:= 'S';
	SET Salida_NO		:= 'N';
	SET Cadena_Vacia	:= ' ';
	SET Cons_Cero		:= '0';

	-- Asignacion de Variables
	SET Var_Estatus			:= 'NI';
	SET Var_SiInserta		:= 'S';
	SET Aud_FechaActual		:= NOW();
	SET Var_NumIdenRep		:= 0;

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-ARCHIVOCARGADEPREFALT');
				SET Var_Control:= 'sqlException' ;
			END;

		SET Var_FechaSistema 		:= (SELECT FechaSistema FROM PARAMETROSSIS);
		SET Var_FolioOperacion 		:= (SELECT IFNULL(MAX(FolioCargaID),Entero_Cero)+1 FROM ARCHIVOCARGADEPREF);
		SET Par_NumIdenArchivo		:= IFNULL(Par_NumIdenArchivo, Entero_Cero);
		SET Var_DepRefMesAnterior	:= LEFT(FNPARAMGENERALES('DepRefMesAnterior'),1);
		SET Var_DepRefMesAnterior	:= IFNULL(Var_DepRefMesAnterior,Salida_NO);
		SET Var_FechaSisIni			:= DATE_FORMAT(Var_FechaSistema, '%Y-%m-01');

		SELECT  NumCtaInstit INTO Var_CuentaBancaria
		FROM CUENTASAHOTESO
		WHERE InstitucionID = Par_InstitucionID
			AND NumCtaInstit = Par_NumCtaInstit;

		IF(Par_TipoMov IN (11,13,15,17))THEN
			SELECT  COUNT(NumIdenArchivo)AS NumIdenArchivo INTO Var_NumIdenRep
			FROM ARCHIVOCARGADEPREF
			WHERE NumIdenArchivo = Par_NumIdenArchivo
				  AND NumTran = Aud_NumTransaccion;

			IF(Var_NumIdenRep > Entero_Cero)THEN
				SET Par_Validacion :='El numero de transaccion esta repetido.';
				SET Par_NumVal := 16;
			END IF;
		END IF;

		# VALIDA SI SE PUEDEN APLICAR O NO LOS DEPÓSITOS EN MESES ANTERIORES AL MES DEL SISTEMA.
		IF(Var_DepRefMesAnterior = Salida_NO)THEN
			IF(Par_FechaOperacion < Var_FechaSisIni)THEN
				SET Par_NumVal := 17;
				SET Par_Validacion := 'No se puede Aplicar Depositos en Meses Anteriores a la Fecha del Sistema.';
			END IF;
		END IF;

		SET Var_NumTran := Aud_NumTransaccion;
        SET Par_NumeroFila := IFNULL(Par_NumeroFila,Entero_Cero);
        SET Par_AplicarDeposito := IFNULL(Par_AplicarDeposito,Cadena_Vacia);
        SET Par_NombreArchivoCarga := IFNULL(Par_NombreArchivoCarga,Cadena_Vacia);


		INSERT INTO ARCHIVOCARGADEPREF (
			NumTran, 				FolioCargaID,			CuentaAhoID,			NumeroMov,			InstitucionID,
            FechaCarga,				FechaAplica,			NatMovimiento,			MontoMov,			TipoMov,
			DescripcionMov,			ReferenciaMov,			Estatus,				MontoPendApli,		TipoDeposito,
            TipoCanal,				NumIdenArchivo,			MonedaId,				Validacion,  		NumVal,
			NumeroFila,				AplicarDeposito,		NombreArchivoCarga,
            EmpresaID,				Usuario,				FechaActual,			DireccionIP,		ProgramaID,
            Sucursal,				NumTransaccion
		)VALUES(
			Var_NumTran,			Var_FolioOperacion, 	Var_CuentaBancaria,		Entero_Cero,		Par_InstitucionID,
            Var_FechaSistema,		Par_FechaOperacion,		Par_NatMovimiento,		Par_MontoMov,		Par_TipoMov,
            Par_DescripcionMov,		Par_ReferenciaMov,		Var_Estatus,			Par_MontoPendApli,	Par_TipoDeposito,
            Par_TipoCanal,			Par_NumIdenArchivo,		Par_Moneda,				Par_Validacion,		Par_NumVal,
			Par_NumeroFila,			Par_AplicarDeposito,	Par_NombreArchivoCarga,
            Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
            Aud_Sucursal,			Aud_NumTransaccion
		);
		SET Par_NumErr := 0;
		SET Par_ErrMen := 'Archivo Cargado Correctamente';
		SET Var_Control:= 'institucionID';

	END ManejoErrores;

	IF(Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_NumTran AS Consecutivo;
	END IF;

END TerminaStore$$