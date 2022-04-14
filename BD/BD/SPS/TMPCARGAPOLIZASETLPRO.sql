DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPCARGAPOLIZASETLPRO`;
DELIMITER $$

CREATE PROCEDURE `TMPCARGAPOLIZASETLPRO`(
# =====================================================================================
# --- STORED PARA VALIDAR LOS REGISTROS DE LA CARGA DE POLIZAS DEL ETL CargaPolizas ---
# =====================================================================================
    Par_NumTransaccion   	BIGINT(20),  	-- Numero de transaccion

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
  )
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
    DECLARE Var_Consecutivo   	VARCHAR(100);     	-- variable consecutivo
	DECLARE Var_Control       	VARCHAR(100);     	-- variable de control
    DECLARE Var_FechaSistema	DATE;				-- Fecha sistema

    -- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia    CHAR(1);        		-- Cadena vacia
	DECLARE Fecha_Vacia     DATE;         			-- Fecha vacia
	DECLARE Entero_Cero     INT(1);           		-- Entero cero
	DECLARE Decimal_Cero    DECIMAL(14,2);    		-- decimal cero
	DECLARE Salida_SI       CHAR(1);          		-- Salida si

	DECLARE Salida_NO       CHAR(1);          		-- Salida no
	DECLARE Entero_Uno      INT(11);          		-- entero uno
	DECLARE Cons_NO         CHAR(1);          		-- Constante no
    DECLARE Grupo_Detalle   CHAR(1);      			-- Grupo detalle poliza D
    DECLARE Cons_SI			CHAR(1);      			-- Constante si

    DECLARE Grupo_Encabezado CHAR(1);      			-- Grupo encabezado poliza E

    -- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia        := '';
	SET Fecha_Vacia         := '1900-01-01';
	SET Entero_Cero         := 0;
	SET Decimal_Cero      	:= 0.0;
	SET Salida_SI           := 'S';

	SET Salida_NO           := 'N';
	SET Entero_Uno          := 1;
	SET Cons_NO             := 'N';
	SET Grupo_Detalle     	:= 'D';
    SET Cons_SI				:= 'S';

	SET Grupo_Encabezado   	:= 'E';

  ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
		  SET Par_NumErr = 999;
		  SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				  'esto le ocasiona. Ref: SP-TMPCARGAPOLIZASETLPRO');
		  SET Var_Control = 'SQLEXCEPTION';
		END;

        SET Var_FechaSistema :=(SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

		-- Actualiza la fecha del sistema y la fecha actual
        UPDATE TMPCARGAPOLIZASETL SET
			FechaSistema = Var_FechaSistema,
            FechaActual = NOW(),
			CuentaCompleta	= IFNULL(CuentaCompleta,Cadena_Vacia),
            Referencia	= IFNULL(Referencia,Cadena_Vacia),
            Fecha	= IFNULL(Fecha,Fecha_Vacia),
            Cargos	= IFNULL(Cargos,Decimal_Cero),
            Abonos	= IFNULL(Abonos,Decimal_Cero),
            DescripPoliza	= IFNULL(DescripPoliza,Cadena_Vacia),
            DescripCuenta	= IFNULL(DescripCuenta,Cadena_Vacia),
            Grupo	= IFNULL(Grupo,Cadena_Vacia),
            DescripCtaCompleta	= IFNULL(DescripCtaCompleta,Cadena_Vacia)
		WHERE NumTransaccion = Par_NumTransaccion;

		-- Valida que los centros de costo existan
        UPDATE TMPCARGAPOLIZASETL TMP, CENTROCOSTOS CEN SET
			TMP.ValidoCenCosID = Cons_SI
		WHERE TMP.CentroCostoID = CEN.CentroCostoID
			AND TMP.NumTransaccion = Par_NumTransaccion;

		-- Valida que las cuentas completas contables existan
        UPDATE TMPCARGAPOLIZASETL TMP, CUENTASCONTABLES CTA SET
			TMP.ValidoCtaComp = Cons_SI,
            TMP.Grupo = CTA.Grupo,
            TMP.DescripCtaCompleta = CTA.Descripcion
		WHERE TMP.CuentaCompleta = CTA.CuentaCompleta
			AND TMP.NumTransaccion = Par_NumTransaccion;

		-- Actualiza los registros de centros de costo que no existen
        UPDATE TMPCARGAPOLIZASETL SET
            DesPertenece = "El Centro de Costo No Existe"
		WHERE NumTransaccion = Par_NumTransaccion
            AND ValidoCenCosID = Cons_NO;

		-- Actualiza los registros de cuentas que son encabezados
        UPDATE TMPCARGAPOLIZASETL SET
            DesPertenece = "La Cuenta Contable es Encabezado"
		WHERE NumTransaccion = Par_NumTransaccion
            AND Grupo = Grupo_Encabezado;

		-- Actualiza los registros exitosos
        UPDATE TMPCARGAPOLIZASETL SET
			EsExitoso = Cons_SI,
            DesPertenece = "Existe"
		WHERE NumTransaccion = Par_NumTransaccion
			AND ValidoCenCosID = Cons_SI
            AND ValidoCtaComp = Cons_SI
            AND Grupo = Grupo_Detalle;

		-- Borra registros de dias pasados
        DELETE FROM TMPCARGAPOLIZASETL
        WHERE FechaSistema < Var_FechaSistema;

		SET Par_NumErr    	:= Entero_Cero;
		SET Par_ErrMen    	:= 'Carga Polizas Realizada Exitosamente';
		SET Var_Control   	:= '';
		SET Var_Consecutivo := Entero_Cero;

  END ManejoErrores;

  IF (Par_Salida = Salida_SI) THEN
    SELECT
      Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

  END IF;

END TerminaStore$$