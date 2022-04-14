-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORADEPREAMORTIPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORADEPREAMORTIPRO`;DELIMITER $$

CREATE PROCEDURE `BITACORADEPREAMORTIPRO`(
# ==============================================================================================================
# ------- STORED DE PROCESO DE MOVIMIENTOS DE DEPRECIACION Y AMORTIZACION DE ACTIVOS ---------
# ==============================================================================================================
    Par_ActivoID			INT(11), 		-- Idetinficador del activo
    Par_TipoActivoID		INT(11), 		-- Idetinficador del tipo de activo
    Par_FechaAdquisicion 	DATE, 			-- Fecha de Adquisicion
    Par_ProveedorID			INT(11), 		-- ID  de proveedor
    Par_NumFactura			VARCHAR(50), 	-- Numero de factura

    Par_Moi					DECIMAL(16,2), 	-- Monto Original Inversion(MOI)
	Par_DepreciadoAcumu		DECIMAL(16,2),	-- Depreciado Acumulado
	Par_TotalDepreciar		DECIMAL(16,2),	-- Total por Depreciar
    Par_MesesUsos			INT(11), 		-- Meses de Uso
    Par_PolizaFactura		BIGINT(12), 	-- Poliza Factura

    Par_TipoProceso			INT(11),		-- Tipo de proceso 1= alta, 2= modificacion
    Par_FechaRegistro	 	DATE, 			-- Fecha de registro del activo

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

    DECLARE Var_Consecutivo			VARCHAR(100);   	-- Variable consecutivo
	DECLARE Var_Control         	VARCHAR(100);   	-- Variable de Control
    DECLARE Var_DepreciacionAnual 	DECIMAL(14,2);		-- Porcentaje depreciacion anual
    DECLARE Var_TiempoAmortiMeses	INT(11);			-- Tiempo Amortizar en Meses
    DECLARE Var_DepreAmortiID 		INT(11);
    DECLARE Var_EsEditable			CHAR(1);			-- variable para identificar si el activo ya fue depreciado

    DECLARE Var_DepreContaAnual		DECIMAL(16,2);		-- Monto Depreciacion Contable Anual
    DECLARE Var_Anio				INT(11);
    DECLARE Var_Mes					INT(11);
    DECLARE Var_FechaDepre			DATE;
    DECLARE Var_MontoDepreciar		DECIMAL(16,2);

    DECLARE Var_SaldoPorDepreciar   DECIMAL(16,2);
    DECLARE Var_NumMesesDepre		INT(11);

    -- DECLARACION DE CONSTANTES

	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno
    DECLARE Est_Aplicado		CHAR(1);
    DECLARE Cons_SI				CHAR(1);
    DECLARE Cons_NO				CHAR(1);

	DECLARE Entero_Dos	     	INT(1);       		-- Constante Entero cero 0

    -- ASIGNACION DE CONSTANTES

	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
    SET Est_Aplicado			:= 'A';
	SET Cons_SI          		:= 'S';
	SET Cons_NO           		:= 'N';

	SET Entero_Dos          	:= 2;


	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-BITACORADEPREAMORTIPRO');
			SET Var_Control = 'SQLEXCEPTION';
		END;


		IF(IFNULL(Par_MesesUsos, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr 		:= 1;
			SET Par_ErrMen 		:= 'El Numero de Meses de Uso debe ser Mayor a Cero';
			SET Var_Control		:= 'mesesUso';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;


		-- SI SE REALIZA UNA MODIFICACION AL ACTIVO SE ELIMINAR LOS REGISTROS ANTERIORES
        IF(Par_TipoProceso = Entero_Dos)THEN
			-- VALIDAMOS SI EL ACTIVO YA SE DEPRECIO UNA VEZ
			SET Var_DepreAmortiID := (SELECT MIN(DepreAmortiID) FROM BITACORADEPREAMORTI WHERE ActivoID = Par_ActivoID AND Estatus = Est_Aplicado);
			SET Var_DepreAmortiID :=IFNULL(Var_DepreAmortiID,Entero_Cero);

            IF(Var_DepreAmortiID > Entero_Cero)THEN
				-- SI EXISTE UN ID DE DEPRECIACION NO SE PODRA MODIFICAR
				SET Par_NumErr 		:= 1;
				SET Par_ErrMen 		:= 'El activo ya fue aplicado en el proceso de depreciacion y amortizacion, no es posible modificar';
				SET Var_Control		:= 'estatus';
				SET Var_Consecutivo	:= Entero_Cero;
				LEAVE ManejoErrores;
			ELSE
				-- AUN NO SE DEPRECIA EL ACTIVO SI SE PUEDE MODIFICAR
				DELETE FROM BITACORADEPREAMORTI
				WHERE ActivoID = Par_ActivoID;

			END IF;
        END IF;

		--  PREVIO DE LO QUE SE AMORTIZARA O DEPRECIARA EN EL TRANSCURSO DE LA VIDA DEL ACTIVO.

        -- CONSULTA TIPO DE ACTIVO
        SELECT DepreciacionAnual, TiempoAmortiMeses
			INTO Var_DepreciacionAnual, Var_TiempoAmortiMeses
        FROM TIPOSACTIVOS
        WHERE TipoActivoID = Par_TipoActivoID;

        -- CALCULA MONTO DEPRECIACION CONTABLE ANUAL = (moi * %depreciacion anual)/100        --
        SET Var_DepreContaAnual :=(Par_Moi * Var_DepreciacionAnual)/100;

        -- SE EMPIEZA A DEPRECIAR EN EL MES SIGUIENTE A LA FECHA DEL REGISTRO DEL ACTIVO
		SET Var_FechaDepre := Par_FechaRegistro;

        -- SALDO POR DEPRECIAR
        SET Var_SaldoPorDepreciar := Par_TotalDepreciar;

		-- VALIDAMOS SI EL PORCENTAJE DE DEPRECIACION ES MAYOR A CERO
        IF(Var_DepreciacionAnual > Entero_Cero)THEN
			-- CALCULA MONTO A DEPRECIAR
			SET Var_MontoDepreciar := IFNULL((Var_DepreContaAnual/Par_MesesUsos),Entero_Cero);

			-- VALIDA SI EXISTE UN MONTO POR DEPRECIAR
			WHILE(Var_SaldoPorDepreciar > Entero_Cero) DO
				-- OBTIENE EL MES A DEPRECIAR
				SET Var_FechaDepre := DATE_ADD(Var_FechaDepre, INTERVAL 1 MONTH);

				-- OBTIENE ANIO Y MES A DEPRECIAR
				SET Var_Anio := YEAR(Var_FechaDepre);
				SET Var_Mes := MONTH(Var_FechaDepre);

				-- VALIDAMOS SI EL SALDO POR DEPRECIAR ES MENOR AL MONTO POR DEPRECIAR ES LA ULTIMA DEPRECIACION
				IF(Var_SaldoPorDepreciar < Var_MontoDepreciar) THEN
					SET Var_MontoDepreciar = Var_SaldoPorDepreciar;
				END IF;

				-- SUMA EL DEPRECIADO ACUMULADO
				SET Par_DepreciadoAcumu := Par_DepreciadoAcumu + Var_MontoDepreciar;

				-- OBTIENE SALDO POR DEPRECIAR
				SET Var_SaldoPorDepreciar := Par_Moi - Par_DepreciadoAcumu;

				CALL `BITACORADEPREAMORTIALT`(
					Par_ActivoID,		Par_Moi,				Var_DepreciacionAnual,	Par_MesesUsos,				Var_DepreContaAnual,
					Var_Anio,			Var_Mes,				Var_MontoDepreciar,		Par_DepreciadoAcumu,		Var_SaldoPorDepreciar,
					'R',				Fecha_Vacia,			Entero_Cero,			Entero_Cero,
					Salida_NO, 			Par_NumErr, 			Par_ErrMen, 			Par_EmpresaID,      		Aud_Usuario,
					Aud_FechaActual,    Aud_DireccionIP,    	Aud_ProgramaID, 		Aud_Sucursal,       		Aud_NumTransaccion);

				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

			END WHILE;
		ELSE
			-- CALCULA MONTO A DEPRECIAR
			SET Var_MontoDepreciar := IFNULL(((Par_Moi-Par_DepreciadoAcumu)/Par_MesesUsos),Entero_Cero);
			SET Var_NumMesesDepre := Entero_Uno;

			-- VALIDA SI EXISTE UN MONTO POR DEPRECIAR
			WHILE(Var_NumMesesDepre <=  Par_MesesUsos) DO
				-- OBTIENE EL MES A DEPRECIAR
				SET Var_FechaDepre := DATE_ADD(Var_FechaDepre, INTERVAL 1 MONTH);

				-- OBTIENE ANIO Y MES A DEPRECIAR
				SET Var_Anio := YEAR(Var_FechaDepre);
				SET Var_Mes := MONTH(Var_FechaDepre);

				-- VALIDAMOS SI ES LA ULTIMA DEPRECIACION EL MONTO A DEPRECIA ES LO QUE RESTA DEL MONTO DEL ACTIVO
				IF(Var_NumMesesDepre = Par_MesesUsos) THEN
					SET Var_MontoDepreciar = Par_Moi - Par_DepreciadoAcumu;
				END IF;

				-- SUMA EL DEPRECIADO ACUMULADO
				SET Par_DepreciadoAcumu := Par_DepreciadoAcumu + Var_MontoDepreciar;

				-- OBTIENE SALDO POR DEPRECIAR
				SET Var_SaldoPorDepreciar := Par_Moi - Par_DepreciadoAcumu;

				CALL `BITACORADEPREAMORTIALT`(
					Par_ActivoID,		Par_Moi,				Var_DepreciacionAnual,	Par_MesesUsos,				Var_DepreContaAnual,
					Var_Anio,			Var_Mes,				Var_MontoDepreciar,		Par_DepreciadoAcumu,		Var_SaldoPorDepreciar,
					'R',				Fecha_Vacia,			Entero_Cero,			Entero_Cero,
					Salida_NO, 			Par_NumErr, 			Par_ErrMen, 			Par_EmpresaID,      		Aud_Usuario,
					Aud_FechaActual,    Aud_DireccionIP,    	Aud_ProgramaID, 		Aud_Sucursal,       		Aud_NumTransaccion);

				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

                -- AUMENTE EL MES A DEPRECIAR SIGUIENTE
                SET Var_NumMesesDepre := Var_NumMesesDepre + Entero_Uno;

			END WHILE;
        END IF;



		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= CONCAT('Proceso Realizado Exitosamente:',CAST(Par_TipoActivoID AS CHAR) );
		SET Var_Control		:= 'activoID';
		SET Var_Consecutivo	:= Par_TipoActivoID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$