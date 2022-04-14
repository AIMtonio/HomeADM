-- GENERATARDEBSAFIPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `GENERATARDEBSAFIPRO`;
DELIMITER $$

CREATE PROCEDURE `GENERATARDEBSAFIPRO`(
Par_Salida				CHAR(1),
INOUT Par_NumErr		INT(11),
INOUT Par_ErrMen		VARCHAR(400),
INOUT Par_Consecutivo	BIGINT(12),

Aud_EmpresaID			INT(11),
Aud_Usuario				INT(11),

Aud_FechaActual			DATETIME,
Aud_DireccionIP			VARCHAR(15),
Aud_ProgramaID			VARCHAR(50),
Aud_Sucursal			INT(11),
Aud_NumTransaccion		BIGINT(20)
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

-- Constantes
DECLARE Cadena_Vacia	CHAR(1);
DECLARE	Entero_Cero		INT(1);
DECLARE Entero_Uno		INT(1);
DECLARE SalidaSI		CHAR(1); 		# Constante Cadena Si
DECLARE SalidaNo		CHAR(1); 		# Constante Salida No
DECLARE Fecha_Vacia		DATE; 			# Constante Fecha Vacía
DECLARE Cadena_P		CHAR(1);		# Cadena P proceso

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

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
								'esto le ocasiona. Ref: SP-GENERATARDEBSAFIPRO');
		SET Var_Control:= 'SQLEXCEPTION' ;
	END;

	SELECT	LOT.LoteDebSAFIID,	LOT.FechaRegistro,	RIGHT(CONCAT('00000',	LOT.SucursalSolicita),5),	LOT.NumTarjetas,	TIT.TipoProsaID,
			TIT.VigenciaMeses,	TIT.ColorTarjeta,	LOT.DireccionIP,									LOT.Sucursal,		LOT.NumTransaccion,
			LOT.EsAdicional, 	TIT.Descripcion,	LOT.ServiceCode, 									TIT.TipoTarjetaDebID
	INTO 	Num_Solici,			FechaSolici,		Num_Sucurs,											SAFI_CantTarj,		Tipo_Tarjeta,
			Vigencia_Meses,		ColorPlastico,		DireccionIP,										Sucursal,			NumTransaccion,
			EsAdicional,		DescripcionTarje,	ServiceCode,										TipoTarjetaDebID
	FROM		LOTETARJETADEBSAFI	LOT
    INNER JOIN	TIPOTARJETADEB	TIT
		ON	TIT.TipoTarjetaDebID	= LOT.TipoTarjetaDebID
		AND	LOT.Estatus	= Sta_Solici;

		SET	Var_ContaRegis	:= Entero_Cero;
		SET Var_FechaActual := NOW();

		-- SE OBTIENE LA FECHA DEL SISTEMA PARA CALCULAR LA VIGENCIA
		SELECT FechaSistema
			INTO Var_FechaSistema
		FROM PARAMETROSSIS LIMIT 1;
		SET FechaVigencia := DATE(DATE_ADD(Var_FechaSistema, INTERVAL Vigencia_Meses MONTH));
		SET Var_FechaVigencia := DATE_FORMAT(FechaVigencia, '%m/%y');

		WHILE (Var_ContaRegis < SAFI_CantTarj)DO
			SET Var_CLABE := Cadena_Vacia;

			-- EVALUA SI EXISTE LA TARJETA EN LAS EXCEPCIONES, SI EXISTE GENERA OTRA
			SET Var_CuentaExcep := Entero_Cero;
			loopExcep: WHILE (Var_CuentaExcep < Entero_Uno)DO
	            CALL GENERATARJETAPRO (	Var_CLABE,		TipoTarjetaDebID, 	Var_NumTitual,	SalidaNo,			Par_NumErr,
	            						Par_ErrMen,		Entero_Cero,		Entero_Cero,	Var_FechaActual,	Cadena_Vacia,
	            						Aud_ProgramaID,	Entero_Cero,		NumTransaccion);
	            IF (Par_NumErr <> Entero_Cero) THEN
			        LEAVE ManejoErrores;
			    END IF;

			    SELECT 	TarExcepcionesId
					INTO Var_TarExcepcionesId
				FROM TAREXCEPCIONES
					WHERE NumTarExcep = Var_CLABE;

				IF(IFNULL(Var_TarExcepcionesId,Entero_Cero)=Entero_Cero)THEN
					SET Var_CuentaExcep := Entero_Uno;
					LEAVE loopExcep;
				END IF;

			    SET Var_CuentaExcep := Entero_Cero;
			END WHILE loopExcep;

            CALL TARLAYDEBSAFIALT(	Entero_Cero,		Num_Solici,			Cadena_P,				FechaSolici,	Cadena_Vacia,
            						Var_CLABE,			Cadena_Vacia,		Cadena_Vacia,			Cadena_Vacia,	Var_FechaVigencia,
            						Cadena_Vacia,		SalidaNo,			Par_NumErr,				Par_ErrMen,		Entero_Cero,
            						Entero_Cero,		Var_FechaActual,	DireccionIP,			Aud_ProgramaID,	Sucursal,
            						NumTransaccion);
            IF (Par_NumErr <> Entero_Cero) THEN
		        LEAVE ManejoErrores;
		    END IF;

			SET Var_ContaRegis := Var_ContaRegis + Entero_Uno;

        END WHILE;

	SET Par_NumErr      := 0;
	SET Par_ErrMen      := 'Lote de tarjetas generado con exito.';
	SET Par_Consecutivo := 0;
	SET Var_Control		:= 'tarLayDebSAFIID';

	END ManejoErrores;
-- SI LA SALIDA ES SI DEVUELVE EL MENSAJE DE EXITO
IF (SalidaSI = SalidaSI) THEN
    SELECT	Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control	AS Control,
			Par_Consecutivo AS Consecutivo;
END IF;

END TerminaStore$$
