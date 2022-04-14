-- REGISTRATARDEBSAFIPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGISTRATARDEBSAFIPRO`;
DELIMITER $$

CREATE PROCEDURE `REGISTRATARDEBSAFIPRO`(
	Par_CompTarjeta 			VARCHAR(16),					-- Compuesto de SubBin con Consecutivo de Tarjeta a Registrar

	Par_Salida					CHAR(1),						-- Parametro de Salida
	INOUT Par_NumErr			INT(11),						-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),					-- Mensaje de Error
	INOUT Par_Consecutivo		BIGINT(12),						-- Consecutivo de la operacion

	Aud_EmpresaID				INT(11),						-- Parametro de Auditoria
	Aud_Usuario					INT(11),						-- Parametro de Auditoria

	Aud_FechaActual				DATETIME,						-- Parametro de Auditoria
	Aud_DireccionIP				VARCHAR(15),					-- Parametro de Auditoria
	Aud_ProgramaID				VARCHAR(50),					-- Parametro de Auditoria
	Aud_Sucursal				INT(11),						-- Parametro de Auditoria
	Aud_NumTransaccion			BIGINT(20)						-- Parametro de Auditoria
)
TerminaStore: BEGIN
-- Varables
DECLARE	Var_ContaRegis			INT(11);
DECLARE Var_FechaActual			DATETIME;
DECLARE Sta_Solici        		INT(11);
DECLARE Var_Cadena_Cero			CHAR(1);
DECLARE Var_NumTitual			INT(11);
DECLARE Var_Control				VARCHAR(30);
DECLARE Var_TarExcepcionesId	INT(11);
DECLARE Var_FechaSistema		DATE;		-- Fecha del sistema

DECLARE Num_Solici			INT(11);
DECLARE FechaSolici			DATE;
DECLARE Num_Sucurs			CHAR(5);
DECLARE SAFI_CantTarj		INT(11);
DECLARE Tipo_Tarjeta		CHAR(4);
DECLARE Vigencia_Meses		INT(11);
DECLARE ColorPlastico		CHAR(2);
DECLARE DireccionIP			VARCHAR(15);
DECLARE Sucursal 			INT(11);
DECLARE EsAdicional 		CHAR(1);
DECLARE DescripcionTarje	VARCHAR(50);
DECLARE ServiceCode			CHAR(3);
DECLARE TipoTarjetaDebID	INT(11);
DECLARE FechaVigencia		DATE;
DECLARE Var_FechaVigencia	CHAR(5);
DECLARE NumTransaccion		BIGINT(20);
DECLARE Var_CLABE		    VARCHAR(16);
DECLARE Var_CuentaExcep		INT(11);
DECLARE Var_Bin				VARCHAR(8);			-- BIN de la tarjetas
DECLARE Var_SubBin 			VARCHAR(2);			-- SubBin de la tarjeta
DECLARE Var_TarjetaCompleta VARCHAR(16);		-- Numero de tarjeta

-- Constantes
DECLARE Cadena_Vacia		CHAR(1);
DECLARE	Entero_Cero			INT(1);
DECLARE Entero_Uno			INT(1);
DECLARE SalidaSI			CHAR(1); 			# Constante Cadena Si
DECLARE SalidaNo			CHAR(1); 			# Constante Salida No
DECLARE Fecha_Vacia			DATE; 				# Constante Fecha Vacía
DECLARE Cadena_P			CHAR(1);			# Cadena P proceso
DECLARE Var_DigVerificador	CHAR(1);			-- Digito verificador

-- Asignación de Constantes
SET Entero_Cero 		:= 0;				# Constante cero
SET SalidaSI			:= 'S'; 			# Constante Cadena Si
SET SalidaNo 			:= 'N'; 			# Constante Salida No
SET Cadena_Vacia		:= '';				# Cadena Vacia
SET Var_NumTitual		:= 1;				# Es tarjeta titular
SET Fecha_Vacia			:= '1900-01-01'; 	# Constante Fecha Vacía
SET Sta_Solici        	:= 1; 				# Valor de estatus Tarjetas Solicitadas
SET Entero_Uno			:= 1;				# Constante entero uno
SET Cadena_P			:= 'P';				# Cadena P proceso

SET Par_CompTarjeta := IFNULL(Par_CompTarjeta, Cadena_Vacia);

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
								'esto le ocasiona. Ref: SP-REGISTRATARDEBSAFIPRO');
		SET Var_Control:= 'SQLEXCEPTION' ;
	END;

	IF(Par_CompTarjeta = Cadena_Vacia) THEN
		SET Par_NumErr := 1;
        SET Par_ErrMen := 'Especifique el compuesto de la tarjeta a registrar.';
        SET Var_Control := 'compTarjeta';
        SET Par_Consecutivo := 0;
        LEAVE ManejoErrores;
	END IF;

	SELECT		LOT.LoteDebSAFIID,	LOT.FechaRegistro,	RIGHT(CONCAT('00000',	LOT.SucursalSolicita),5),	LOT.NumTarjetas,		TIT.TipoProsaID,
				TIT.VigenciaMeses,	TIT.ColorTarjeta,	LOT.DireccionIP,									LOT.Sucursal,			LOT.NumTransaccion,
				LOT.EsAdicional, 	TIT.Descripcion,	LOT.ServiceCode, 									TIT.TipoTarjetaDebID,	TIT.NumSubBIN,
				TB.NumBIN
		INTO 	Num_Solici,			FechaSolici,		Num_Sucurs,											SAFI_CantTarj,			Tipo_Tarjeta,
				Vigencia_Meses,		ColorPlastico,		DireccionIP,										Sucursal,				NumTransaccion,
				EsAdicional,		DescripcionTarje,	ServiceCode,										TipoTarjetaDebID,		Var_SubBin,
				Var_Bin
		FROM LOTETARJETADEBSAFI	LOT
		INNER JOIN TIPOTARJETADEB	TIT ON	TIT.TipoTarjetaDebID = LOT.TipoTarjetaDebID
		INNER JOIN TARBINPARAMS TB ON TIT.TarBinParamsID = TB.TarBinParamsID
		WHERE LOT.Estatus = Sta_Solici;

	SET SAFI_CantTarj := IFNULL(SAFI_CantTarj, Entero_Cero);
	SET Var_FechaActual := NOW();

	-- SE OBTIENE LA FECHA DEL SISTEMA PARA CALCULAR LA VIGENCIA
	SELECT FechaSistema
		INTO Var_FechaSistema
	FROM PARAMETROSSIS LIMIT 1;
	SET FechaVigencia := DATE(DATE_ADD(Var_FechaSistema, INTERVAL Vigencia_Meses MONTH));
	SET Var_FechaVigencia := DATE_FORMAT(FechaVigencia, '%y/%m');

	SET Var_TarjetaCompleta := CONCAT(Var_Bin, Par_CompTarjeta);
	SET Var_DigVerificador := FNGENERADIGVERI(Var_TarjetaCompleta);
	SET Var_TarjetaCompleta := CONCAT(Var_TarjetaCompleta, Var_DigVerificador);

	IF (SAFI_CantTarj = Entero_Cero) THEN
		SET Par_NumErr := 1;
        SET Par_ErrMen := 'No se encontro el lote de tarjetas por registar.';
        SET Var_Control := 'LoteDebSAFIID';
        SET Par_Consecutivo := 0;
        LEAVE ManejoErrores;
    END IF;

    SELECT 		TarExcepcionesId
		INTO 	Var_TarExcepcionesId
		FROM TAREXCEPCIONES
		WHERE NumTarExcep = Var_TarjetaCompleta;

	IF(IFNULL(Var_TarExcepcionesId,Entero_Cero)<>Entero_Cero)THEN
		SET Par_NumErr := 2;
        SET Par_ErrMen := 'La tarjeta ya ha sido registrada previamente.';
        SET Var_Control := 'TarjetaID';
        SET Par_Consecutivo := 0;
        LEAVE ManejoErrores;
	END IF;

	-- CREAR BITACORA DE CUENTA CLABE
    CALL BITACORATARJETAALT(
    	NumTransaccion,			Var_TarjetaCompleta,	Cadena_Vacia,    	Fecha_Vacia,     	Var_FechaActual,
        SalidaNo,            	Par_NumErr,         	Par_ErrMen,     	Entero_Cero,  		Entero_Cero,
        Var_FechaActual, 		DireccionIP,    		Aud_ProgramaID, 	Sucursal,  	 		NumTransaccion
    );

    -- VALIDA QUE NO FALLE EL INSERT EN LA BITACORA
    IF (Par_NumErr > Entero_Cero) THEN
        SET Var_Control := Entero_Cero;
        LEAVE ManejoErrores;
    END IF;

    -- Guardamos la informacion del Layout
	CALL TARLAYDEBSAFIALT(	Entero_Cero,			Num_Solici,			Cadena_P,				FechaSolici,	Cadena_Vacia,
    						Var_TarjetaCompleta,	Cadena_Vacia,		Cadena_Vacia,			Cadena_Vacia,	Var_FechaVigencia,
    						Cadena_Vacia,			SalidaNo,			Par_NumErr,				Par_ErrMen,		Entero_Cero,
    						Entero_Cero,			Var_FechaActual,	DireccionIP,			Aud_ProgramaID,	Sucursal,
    						NumTransaccion);
    IF (Par_NumErr <> Entero_Cero) THEN
        LEAVE ManejoErrores;
    END IF;

    -- Guardamos la informacion de la tarjeta registrada
    CALL TARDEBASIGNADASALT (
    	Var_TarjetaCompleta,	Var_Bin,			Var_SubBin,			Num_Solici,			SalidaNo,
    	Par_NumErr,				Par_ErrMen,			Entero_Cero,		Entero_Cero,		Var_FechaActual,
    	DireccionIP,			Aud_ProgramaID,		Sucursal,			NumTransaccion
    );

    IF (Par_NumErr <> Entero_Cero) THEN
        LEAVE ManejoErrores;
    END IF;

	SET Par_NumErr      := 0;
	SET Par_ErrMen      := 'Lote de tarjetas generado con exito.';
	SET Par_Consecutivo := 0;
	SET Var_Control		:= 'tarLayDebSAFIID';

	END ManejoErrores;
-- SI LA SALIDA ES SI DEVUELVE EL MENSAJE DE EXITO
IF (Par_Salida = SalidaSI) THEN
    SELECT	Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control	AS Control,
			Par_Consecutivo AS Consecutivo;
END IF;

END TerminaStore$$
