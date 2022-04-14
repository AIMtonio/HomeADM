-- ARCHIVOCARGADEPREFPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARCHIVOCARGADEPREFPRO`;
DELIMITER $$

CREATE PROCEDURE `ARCHIVOCARGADEPREFPRO`(
-- ================================================================================
-- ------ STORED PARA PROCESAR LOS REGISTROS DEL LAYOUT DEPOSITOS REFERENCIADOS ---
-- ================================================================================
	Par_NumTran				BIGINT(20),		-- Numero de Transaccion de Carga
	Par_InstitucionID		INT(11),		-- ID institucion bancaria
	Par_NumCtaInstit		VARCHAR(20),	-- Cuenta de la institución bancaria
	Par_BancoEstandar		CHAR(1),		-- Formato de banco o estandar

    Par_Salida    			CHAR(1),		-- Parametro de salida S= si, N= no
    INOUT Par_NumErr 		INT(11),		-- Parametro de salida numero de error
    INOUT Par_ErrMen  		VARCHAR(400),	-- Parametro de salida mensaje de error

    Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
    DECLARE Var_Consecutivo		VARCHAR(100);   	-- Variable consecutivo
	DECLARE Var_Control         VARCHAR(100);   	-- Variable de Control
    DECLARE Var_FechaSistema	DATE;				-- Fecha de sistema
    DECLARE Var_ConsecutivoID	INT(11);			-- Consecutivo id
   	DECLARE Var_MaxConsecutivoID INT(11);      		-- Maximo ID consecutivo a recorrer
	DECLARE Var_FolioCargaID	BIGINT(20);			-- Folio unico de Carga de Archivo a Conciliar
	DECLARE Var_CuentaAhoID		BIGINT(12);			-- Cuenta de Ahorro a Validar
	DECLARE Var_MontoMov		DECIMAL(18,2);		-- Monto del Movimiento
	DECLARE Var_Fecha			DATE;				-- Fecha del Movimiento

    -- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Decimal cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno
	DECLARE Cons_SI       		CHAR(1);   			-- Constante  S, valor si
	DECLARE Cons_NO       		CHAR(1); 			-- Constante  N, valor no

    -- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
	SET Cons_SI          		:= 'S';
	SET Cons_NO           		:= 'N';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-ARCHIVOCARGADEPREFPRO');
			SET Var_Control = 'sqlException';
		END;

		-- FORMARTO LAYOUT ESTANDAR
        IF(Par_BancoEstandar = 'E')THEN

            SET Aud_FechaActual := NOW();
            -- VALIDA NUMERO DE CUENTA DE INSTITUCION
            UPDATE TMPARCHIVOCARGADEPREF SET
				NumCtaInstit = TRIM(LEADING '0' FROM IFNULL(NumCtaInstit,Cadena_Vacia)),
                NumCtaInstitArchivo = TRIM(LEADING '0' FROM IFNULL(NumCtaInstitArchivo,Cadena_Vacia))
			WHERE NumTransaccionCarga = Par_NumTran
				AND NumVal = Entero_Cero;

            UPDATE TMPARCHIVOCARGADEPREF SET
				NumVal = 14,
				Validacion = CONCAT('No Coinciden los Numero de Cuenta. Linea: ', NumeroFila),

				EmpresaID 			= Par_EmpresaID ,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
             WHERE NumTransaccionCarga = Par_NumTran
				AND NumVal = Entero_Cero
                AND NumCtaInstit <> NumCtaInstitArchivo;

            -- VALIDA QUE LA FECHA NO SEA NULA
             UPDATE TMPARCHIVOCARGADEPREF SET
				NumVal = 6,
				Validacion = CONCAT('Formato Incorrecto en Fecha de Operacion. Linea: ', NumeroFila),

				EmpresaID 			= Par_EmpresaID ,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
             WHERE NumTransaccionCarga = Par_NumTran
				AND NumVal = Entero_Cero
                AND FechaOperacionArchivo IS NULL;

            -- VALIDA QUE LA FECHA DEL DEPOSITO NO ESTE FUERA DEL RANGO DE FECHAS
             UPDATE TMPARCHIVOCARGADEPREF SET
				NumVal = 6,
				Validacion = CONCAT('La Fecha esta Fuera del Rango de Fechas. Linea: ', NumeroFila),

				EmpresaID 			= Par_EmpresaID ,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
             WHERE NumTransaccionCarga = Par_NumTran
				AND NumVal = Entero_Cero
                AND (FechaOperacionArchivo < FechaInicial OR FechaOperacionArchivo > FechaFinal);

            -- VALIDA QUE LA REFERENCIA NO SEA MAYOR A 150 CARACTERES
             UPDATE TMPARCHIVOCARGADEPREF SET
				NumVal = 8,
				Validacion = CONCAT('La Descripcion no debe ser mayor a 150 caracteres. Linea: ', NumeroFila),

				EmpresaID 			= Par_EmpresaID ,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
             WHERE NumTransaccionCarga = Par_NumTran
				AND NumVal = Entero_Cero
                AND CHAR_LENGTH(ReferenciaMovArchivo) > 150;

            -- VALIDA LA NATURALEZA
             UPDATE TMPARCHIVOCARGADEPREF SET
				NumVal = 9,
				Validacion = CONCAT('Formato incorrecto para Naturaleza. Linea: ', NumeroFila),

				EmpresaID 			= Par_EmpresaID ,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
             WHERE NumTransaccionCarga = Par_NumTran
				AND NumVal = Entero_Cero
                AND NatMovimientoArchivo NOT IN('C','A');

            -- VALIDA MONTO
			UPDATE TMPARCHIVOCARGADEPREF SET
				MontoMovArchivo = IFNULL(MontoMovArchivo, Entero_Cero)
			WHERE NumTransaccionCarga = Par_NumTran;

            UPDATE TMPARCHIVOCARGADEPREF SET
				NumVal = 10,
				Validacion = CONCAT('Formato Incorrecto para el Monto del Movimiento. Linea: ', NumeroFila),

				EmpresaID 			= Par_EmpresaID ,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
             WHERE NumTransaccionCarga = Par_NumTran
				AND NumVal = Entero_Cero
                AND MontoMovArchivo <= Entero_Cero;

			-- VALIA MONTO PENDIENTE
            UPDATE TMPARCHIVOCARGADEPREF SET
				NumVal = 11,
				Validacion = CONCAT('Formato Incorrecto para el Monto Pendiente por Aplicar. Linea: ', NumeroFila),

				EmpresaID 			= Par_EmpresaID ,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
             WHERE NumTransaccionCarga = Par_NumTran
				AND NumVal = Entero_Cero
                AND MontoPendApliArchivo IS NULL;

			-- VALIDA TIPO CANAL
            UPDATE TMPARCHIVOCARGADEPREF SET
				TipoCanal = IFNULL(TipoCanal, Entero_Cero)
             WHERE NumTransaccionCarga = Par_NumTran;

            UPDATE TMPARCHIVOCARGADEPREF SET
				NumVal = 12,
				Validacion = CONCAT('Valor incorrecto para Tipo de Canal. Linea: ', NumeroFila),

				EmpresaID 			= Par_EmpresaID ,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
             WHERE NumTransaccionCarga = Par_NumTran
				AND NumVal = Entero_Cero
                AND TipoCanalArchivo <= Entero_Cero;

			-- VALIDA TIPO DE DEPOSITO
            UPDATE TMPARCHIVOCARGADEPREF SET
				NumVal = 13,
				Validacion = CONCAT('Valor incorrecto para el Tipo de Deposito. Linea: ', NumeroFila),

				EmpresaID 			= Par_EmpresaID ,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
             WHERE NumTransaccionCarga = Par_NumTran
				AND NumVal = Entero_Cero
                AND TipoDepositoArchivo NOT IN('E','T','C');

			-- VALIDA TIPO DE CANAL
            UPDATE TMPARCHIVOCARGADEPREF TMP
				LEFT JOIN TIPOCANAL TIP
					ON TMP.TipoCanalArchivo = TIP.TipoCanalID SET
				TMP.NumVal = 14,
				TMP.Validacion = CONCAT('El Tipo de Canal no Existe. Linea: ', TMP.NumeroFila),

				TMP.EmpresaID 			= Par_EmpresaID ,
				TMP.Usuario				= Aud_Usuario,
				TMP.FechaActual			= Aud_FechaActual,
				TMP.DireccionIP			= Aud_DireccionIP,
				TMP.ProgramaID			= Aud_ProgramaID,
				TMP.Sucursal			= Aud_Sucursal,
				TMP.NumTransaccion		= Aud_NumTransaccion
             WHERE TMP.NumTransaccionCarga = Par_NumTran
				AND TMP.NumVal = Entero_Cero
                AND TIP.TipoCanalID IS NULL;

            -- Consultar la referencia de pago por instrumento para el tipo de canal 2 cuentas.
            -- ACTUALIZA TODAS LAS REFERENCIAS A N DEL TIPO DE CANAL 2
            UPDATE TMPARCHIVOCARGADEPREF TMP,
				REFPAGOSXINST REF SET
				TMP.ExisteRef 			= 'N',
				TMP.InstrumentoID 		= Entero_Cero,

				TMP.EmpresaID 			= Par_EmpresaID ,
				TMP.Usuario				= Aud_Usuario,
				TMP.FechaActual			= Aud_FechaActual,
				TMP.DireccionIP			= Aud_DireccionIP,
				TMP.ProgramaID			= Aud_ProgramaID,
				TMP.Sucursal			= Aud_Sucursal,
				TMP.NumTransaccion		= Aud_NumTransaccion
             WHERE TMP.NumTransaccionCarga = Par_NumTran
				AND TMP.NumVal = Entero_Cero
                AND TMP.TipoCanalArchivo = 2;

			-- ACTUALIZA SOLO LAS REFERENCIAS QUE COINCIDEN
            UPDATE TMPARCHIVOCARGADEPREF TMP,
				REFPAGOSXINST REF SET
				TMP.ExisteRef = 'S',
				TMP.InstrumentoID  = IFNULL(REF.InstrumentoID, Entero_Cero),

				TMP.EmpresaID 			= Par_EmpresaID ,
				TMP.Usuario				= Aud_Usuario,
				TMP.FechaActual			= Aud_FechaActual,
				TMP.DireccionIP			= Aud_DireccionIP,
				TMP.ProgramaID			= Aud_ProgramaID,
				TMP.Sucursal			= Aud_Sucursal,
				TMP.NumTransaccion		= Aud_NumTransaccion
             WHERE TMP.NumTransaccionCarga = Par_NumTran
				AND TMP.NumVal = Entero_Cero
                AND TMP.TipoCanalArchivo = 2
                AND REF.Referencia = TMP.ReferenciaMovArchivo
                AND REF.TipoCanalID = 2
                AND REF.InstitucionID = TMP.InstitucionID;

			-- ACTUALIZA EL ID DE LOS REGISTROS DE TIPO DE CANAL 2 CUENTAS PARA VALIDAR
			SET @ConsecutivoIDAux := Entero_Cero;
            UPDATE TMPARCHIVOCARGADEPREF TMP SET
				TMP.ConsecutivoIDAux = @ConsecutivoIDAux:=@ConsecutivoIDAux+1,

				TMP.EmpresaID 			= Par_EmpresaID ,
				TMP.Usuario				= Aud_Usuario,
				TMP.FechaActual			= Aud_FechaActual,
				TMP.DireccionIP			= Aud_DireccionIP,
				TMP.ProgramaID			= Aud_ProgramaID,
				TMP.Sucursal			= Aud_Sucursal,
				TMP.NumTransaccion		= Aud_NumTransaccion
			WHERE TMP.NumTransaccionCarga = Par_NumTran
				AND TMP.NumVal = Entero_Cero
                AND TMP.TipoCanalArchivo = 2;

			SET Var_ConsecutivoID := 1;
            SET Var_MaxConsecutivoID := (SELECT MAX(ConsecutivoIDAux) FROM TMPARCHIVOCARGADEPREF TMP
												WHERE TMP.NumTransaccionCarga = Par_NumTran
													AND TMP.NumVal = Entero_Cero
													AND TMP.TipoCanalArchivo = 2);

            -- SE VALIDAN LOS REGISTROS DE TIPO DE CANAL CUENTAS
            WHILE(Var_ConsecutivoID <= Var_MaxConsecutivoID)DO
				SELECT FolioCargaID, IF(ExisteRef = 'S',InstrumentoID, CAST(ReferenciaMovArchivo AS UNSIGNED INTEGER)), MontoMovArchivo, FechaOperacionArchivo
					INTO Var_FolioCargaID, Var_CuentaAhoID, Var_MontoMov, Var_Fecha
                FROM TMPARCHIVOCARGADEPREF
                WHERE NumTransaccionCarga = Par_NumTran
					AND ConsecutivoIDAux = Var_ConsecutivoID;

				SET Par_NumErr 	:= 0;
				SET Par_ErrMen 	:= '';

				CALL DEPCUENTASVAL(
					Var_CuentaAhoID,		Var_MontoMov,		Var_Fecha,			2,
                    Salida_NO, 				Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
                    Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
                );

                IF(Par_NumErr = 3 OR Par_NumErr = 4 OR Par_NumErr = 1 OR Par_NumErr = 2)THEN
					UPDATE TMPARCHIVOCARGADEPREF SET
						NumVal = Par_NumErr,
						Validacion = CONCAT(Par_ErrMen, ' Linea: ', NumeroFila),

						EmpresaID 			= Par_EmpresaID ,
						Usuario				= Aud_Usuario,
						FechaActual			= Aud_FechaActual,
						DireccionIP			= Aud_DireccionIP,
						ProgramaID			= Aud_ProgramaID,
						Sucursal			= Aud_Sucursal,
						NumTransaccion		= Aud_NumTransaccion
					 WHERE NumTransaccionCarga = Par_NumTran
						AND FolioCargaID = Var_FolioCargaID;
				END IF;

                SET Var_ConsecutivoID := Var_ConsecutivoID + 1;
			END WHILE;

			-- REGISTROS CORRECTO
            UPDATE TMPARCHIVOCARGADEPREF SET
				NumVal = 0,
				Validacion = CONCAT('CORRECTO'),

				EmpresaID 			= Par_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
             WHERE NumTransaccionCarga = Par_NumTran
				AND NumVal = Entero_Cero;

        END IF;

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= CONCAT('Archivo de Carga Procesao Exitosamente: ',CAST(Par_NumTran AS CHAR) );
		SET Var_Control		:= '';
		SET Var_Consecutivo	:= Par_NumTran;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) then
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$