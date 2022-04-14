-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRENDASIMPAGOSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARRENDASIMPAGOSPRO`;DELIMITER $$

CREATE PROCEDURE `ARRENDASIMPAGOSPRO`(
# =====================================================================================
# -- STORED PROCEDURE PARA GENERA  EL COTIZADOR.
# =====================================================================================
	Par_Monto					DECIMAL(16,2),		-- Monto
	Par_MontoSegAnual			DECIMAL(16,2),		-- Monto seguro anual
	Par_MontoSegVidaAn			DECIMAL(16,2),		-- Monto seguro de vida
	Par_DiasPago				CHAR(1),			-- Dias e pago
	Par_ValorResidual			DECIMAL(16,2),		-- Valor Residual

	Par_FechaApertura			DATE,				-- Fecha de apertura
	Par_Periodicidad			CHAR(1),			-- Periodicidad
	Par_Plazo					INT(11),			-- Plazo
	Par_Tasa					DECIMAL(16,2),		-- Tasa
	Par_DiaHabil				CHAR(1),			-- Dia habil

	Par_ClienteID				INT(11),			-- Cliente ID
	Par_RentaAnticipada			CHAR(1),			-- Parametro para indicar si se marca la primera cuota como pagada: S o N
	Par_RentasAdelantadas		INT(11),			-- Parametro para marcar las primeras/ultimas N cuotas como pagadas
	Par_Adelanto				CHAR(1),			-- Parametro para definir si se marcan las primeras (P) o las ultimas (U) N cuotas como pagadas

	Par_Salida					CHAR(1),			-- Parametro que indica si el procedimiento devuelve una salida
	INOUT Par_NumErr			INT(11),			-- Parametro que corresponde a un numero de exito o error
	INOUT Par_ErrMen			VARCHAR(400),		-- Parametro que corresponde a un mensaje de exito o error
	INOUT Par_NumTransacSim		BIGINT(20),			-- Numero de transaccion de la simulacion

	INOUT Par_CantCuota			INT(11),			-- Cantidad de la couta
	INOUT Par_FechaPrimerVen	DATE,				-- Fecha primer vencimiento
	INOUT Par_FechaUltimoVen	DATE,				-- Fecha Ultimo vencimiento
	Aud_EmpresaID				INT(11),			-- Parametros de Auditoria
	Aud_Usuario					INT(11),			-- Parametros de Auditoria

	Aud_FechaActual				DATETIME,			-- Parametros de Auditoria
	Aud_DireccionIP				VARCHAR(15),		-- Parametros de Auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametros de Auditoria
	Aud_Sucursal				INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion			BIGINT(20)			-- Parametros de Auditoria
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_Control			VARCHAR(100);		-- Variable de control
	DECLARE Var_CtePagIva		CHAR(1);			 -- VARIABLE PARA  GUARDAR SU EL CLIENTE PAGA O NO IVA
	DECLARE Var_FechaSistema	DATETIME;
	DECLARE Var_ValorRenta		DECIMAL(16,2);		-- PARA OBTENER EL VALOR CALCULADO QUE SIRVE PARA EL VALOR DE RENTA
	DECLARE Var_ValorCalculado	DECIMAL(16,2);		-- PARA EL VALOR DE RENTA
	DECLARE Var_TasaMensual		DECIMAL(16,12); 	-- PARA OBTENER EL VALOR DE TASA MENSUAL
	DECLARE Var_Insoluto		DECIMAL(16,2); 		-- PARA OBTENER EL VALOR INSOLUTO
	DECLARE Var_Interes			DECIMAL(16,2);		-- PARA OBTENER EL VALOR INTERES
	DECLARE Var_Capital			DECIMAL(16,2);		-- PARA OBTENER EL VALOR CAPITAL
	DECLARE Var_Diferencia		DECIMAL(16,2);		-- PARA OBTENER EL VALOR DE DIFERENCIA
	DECLARE Var_IvaInteres		DECIMAL(16,2);		-- PARA GUARDAR EL VALOR DEL IVA
	DECLARE Var_IVA				DECIMAL(16,2);		-- VARIABLE PARA OBTENER EL VALOR DEL IVA
	DECLARE Var_MontoSeg		DECIMAL(16,2);		-- VARIABLE PARA OBTENER EL VALOR MONTO DE SEGURO ANUAL
	DECLARE Var_MontoSegVida	DECIMAL(16,2);		-- VARIABLE PARA OBTENER EL VALOR MONTO DE SEGURO VIDA ANUAL

	DECLARE Var_Contador		INT(11);			-- Contador
	DECLARE Var_AnualMes		INT(11);			-- Numero de meses del anio
	DECLARE Var_DiasGracia		INT(11);			-- Dias de Gracia

	DECLARE Var_NumeroCuotas	INT(11);			-- Numero de coutas
	DECLARE Var_FechaPrimerVen	DATE;				-- Fecha primer vencimiento
	DECLARE Var_FechaUltimoVen	DATE;				-- Fecha de ultimo vencimiento
	DECLARE Var_MontoCuota		DECIMAL(16,2);		-- Monto de la cuota
	DECLARE Var_MontoCuotaGral	DECIMAL(16,2);		-- Monto general de la couta
	DECLARE Var_MontoCuotaUlt	DECIMAL(16,2);		-- Monto ultima cuota
	DECLARE Var_TotalCapital	DECIMAL(16,2);		-- Totaldel capital
	DECLARE Var_TotalInteres	DECIMAL(16,2);		-- Total Interes
	DECLARE Var_TotalIva		DECIMAL(16,2);		-- Total iva
	DECLARE Var_TotalRenta		DECIMAL(16,2);		-- Total renta
	DECLARE Var_TotalPago		DECIMAL(16,2);		-- Total pago

	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);			-- Cadena vacia
	DECLARE Fecha_Vacia			DATE;				-- Fecha vacia
	DECLARE Entero_Cero			INT(11);			-- Entero cero
	DECLARE Entero_Uno			INT(11);			-- Entero uno
	DECLARE Decimal_Cero		DECIMAL(12,2);		-- Decimal cero
	DECLARE Salida_Si			CHAR(1);			-- Salida Si
	DECLARE Salida_No			CHAR(1);			-- Salida No
	DECLARE Var_RentaAntSi		CHAR(1);			-- Renta anticipada
	DECLARE Var_AdelantoPrim	CHAR(1);			-- Valor para marcar como pagadas N primeras cuotas
	DECLARE Var_AdeltantoUlt	CHAR(1);			-- Valor para marcar como pagadas N ultimas cuotas

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia			:= '';				-- Cadena Vacia
	SET Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero				:= 0;				-- Entero en Cero
	SET Entero_Uno				:= 1;				-- Entero UNO
	SET Decimal_Cero			:= 0;				-- Decimal cero
	SET Salida_Si				:= 'S';				-- Permite Salida SI
	SET Salida_No				:= 'N';				-- Permite Salida NO
	SET Var_AnualMes			:= 12;				-- Numero de meses del anio
	SET Var_RentaAntSi			:= 'S';				-- Renta anticipada
	SET Var_AdelantoPrim		:= 'P';				-- Valor para marcar como pagadas N primeras cuotas
	SET Var_AdeltantoUlt		:= 'U';				-- Valor para marcar como pagadas N ultimas cuotas

	-- ASIGNACION DE VARIABLES
	SET Aud_FechaActual			:= NOW();
	SET Var_ValorCalculado		:= Entero_Cero;
	SET Var_ValorRenta			:= Entero_Cero;
	SET Var_Insoluto			:= Entero_Cero;
	SET Var_DiasGracia			:= CAST((SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro LIKE 'DiasGraciaArrenda') AS SIGNED) ;

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr  = 999;
				SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										 'Disculpe las molestias que esto le ocasiona. Ref: SP-ARRENDASIMPAGOSPRO');
				SET Var_Control = 'sqlException';
			END;

		SELECT	FechaSistema
		  INTO	Var_FechaSistema
			FROM PARAMETROSSIS LIMIT 1;

		-- **************************************************************************************
		-- SE MANDA A LLAMAR SP QUE GENERA EL CALENDARIO DE AMORTIZACIONES
		-- **************************************************************************************

        CALL ARRENDASIMFECHASPRO( -- SP para generar el calendario de pagos
			Par_FechaApertura,      Par_Periodicidad,   Par_DiasPago,       Par_Plazo,          Par_DiaHabil,
			Var_DiasGracia,         Salida_No,          Par_NumErr,         Par_ErrMen,         Aud_EmpresaID,
			Aud_Usuario ,           Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		-- **************************************************************************************
		-- SET OBTIENE EL VALOR DE IVA DEPENDIENDO DE SI EL CLIENTE PAGA O NO *******************
		-- **************************************************************************************
		-- se guarda el valor de si el cliente paga o no IVA
		SELECT	PagaIVA
		  INTO	Var_CtePagIva
			FROM CLIENTES
			WHERE	ClienteID = Par_ClienteID;

		IF(IFNULL(Var_CtePagIva, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Var_CtePagIva	:= Salida_Si;
		END IF;

		IF(IFNULL(Aud_Sucursal,Entero_Cero ) = Entero_Cero) THEN
			SET Aud_Sucursal  := (SELECT SucursalMatrizID FROM PARAMETROSSIS);
		END IF;

		SET Var_IVA		:= (SELECT IFNULL(IVA,Decimal_Cero) FROM SUCURSALES WHERE SucursalID = Aud_Sucursal);

		IF (Var_CtePagIva = Salida_No) THEN
			SET Var_IVA := Decimal_Cero;
		END IF;

		-- **************************************************************************************
		-- SE REALIZAN LOS CALCULOS QUE SE UTILIZAN EN EL COTIZADOR *****************************
		-- SE CALCULA EL VALOR CALCULADO Y EL VALOR EN RENTA ************************************
		-- **************************************************************************************
		SET Var_TasaMensual     := (Par_Tasa / 12) / 100 ;
		SET Var_ValorCalculado  := Par_ValorResidual * POWER((Entero_Uno + Var_TasaMensual), Par_Plazo* -Entero_Uno );
		-- CON EL VALOR CALCULADO SE OBTIENE EL VALOR DE RENTA
		SET Var_ValorRenta      := ROUND( (Var_TasaMensual * POWER( (Entero_Uno + Var_TasaMensual) , Par_Plazo) * ( Par_Monto - Var_ValorCalculado  ) )
											/ ( POWER((Entero_Uno + Var_TasaMensual) , Par_Plazo ) - Entero_Uno)    , 2);
		SET Var_ValorRenta      := IFNULL(Var_ValorRenta,Entero_Cero);
		-- **************************************************************************************
		-- SE REALIZAN LOS CALCULOS PARA SEGURO ANUAL *******************************************
		-- **************************************************************************************
		SET Var_MontoSeg        := ROUND( (Var_TasaMensual * POWER( (Entero_Uno + Var_TasaMensual) , Var_AnualMes) * ( Par_MontoSegAnual ) )
										/ ( POWER((1 + Var_TasaMensual) , Var_AnualMes ) - Entero_Uno)  ,2);

		SET Var_MontoSeg        := IFNULL(Var_MontoSeg, Entero_Cero);

		-- **************************************************************************************
		-- SE REALIZAN LOS CALCULOS PARA SEGURO DE VIDA ANUAL ***********************************
		-- **************************************************************************************
		SET Var_MontoSegVida    := ROUND( (Var_TasaMensual * POWER( (Entero_Uno + Var_TasaMensual) , Var_AnualMes) * ( Par_MontoSegVidaAn ) )
										/ ( POWER((1 + Var_TasaMensual) , Var_AnualMes ) - Entero_Uno)  ,2);

		SET Var_MontoSegVida    := IFNULL(Var_MontoSegVida, Entero_Cero);

		-- SE ACTUALIZA EL VALOR CALCULADO EN LA TABLA DE PASO
		UPDATE TMPARRENDAPAGOSIM SET
			Tmp_Renta = Var_ValorRenta
			WHERE NumTransaccion = Aud_NumTransaccion;

		-- SE REALIZA WHILE PARA CALCULAR EL MONTO DE INTERESES Y CAPITAL
		SET Var_Contador    := Entero_Uno;
		SET Var_Insoluto    := IFNULL(Par_Monto, Entero_Cero);

		SET Var_MontoCuotaGral  := Var_ValorRenta;

		WHILE (Var_Contador <= Par_Plazo) DO
			SET Var_Interes     := ROUND(Var_Insoluto   * Var_TasaMensual,2);
			SET Var_Capital     := Var_ValorRenta       - Var_Interes;
			SET Var_Insoluto    := Var_Insoluto         - Var_Capital;
			SET Var_IvaInteres  := ROUND(Var_ValorRenta * Var_IVA, 2);

			-- SE ACTUALIZAN LOS VALORES  EN LA TABLA DE AYUDA
			UPDATE TMPARRENDAPAGOSIM SET
				Tmp_Interes         = Var_Interes,
				Tmp_Capital         = Var_Capital,
				Tmp_Insoluto        = Var_Insoluto,
				Tmp_Renta           = Var_ValorRenta,
				Tmp_Iva             = Var_IvaInteres,
				Tmp_MontoSeg        = Var_MontoSeg,
				Tmp_MontoSegIva     = ROUND(Var_MontoSeg * Var_IVA, 2),
				Tmp_MontoSegVida    = Var_MontoSegVida,
				Tmp_MontoSegVidaIva = ROUND(Var_MontoSegVida * Var_IVA, 2),
				Tmp_PagoTotal       = Var_ValorRenta + Var_IvaInteres + Var_MontoSeg + Var_MontoSegVida +  ROUND(Var_MontoSeg * Var_IVA,2) +  ROUND(Var_MontoSegVida * Var_IVA,2)
				WHERE	NumTransaccion  = Aud_NumTransaccion
				  AND	Tmp_Consecutivo = Var_Contador;

			IF(Var_Contador = Par_Plazo) THEN
				IF(Var_Insoluto > Par_ValorResidual)THEN
					SET Var_Diferencia  := Var_Insoluto - Par_ValorResidual;
					UPDATE TMPARRENDAPAGOSIM    SET
						Tmp_Capital     = Tmp_Capital   + Var_Diferencia,
						Tmp_Renta       = Tmp_Renta     + Var_Diferencia,
						Tmp_Insoluto    = Tmp_Insoluto  - Var_Diferencia
					WHERE   NumTransaccion  = Aud_NumTransaccion
						AND    Tmp_Consecutivo = Var_Contador;
					SET Var_MontoCuotaUlt   := Var_MontoCuotaGral + Var_Diferencia;
				ELSE
					SET Var_Diferencia  := Par_ValorResidual - Var_Insoluto;

					UPDATE TMPARRENDAPAGOSIM SET
						Tmp_Capital     = Tmp_Capital   - Var_Diferencia,
						Tmp_Renta       = Tmp_Renta     - Var_Diferencia,
						Tmp_Insoluto    = Tmp_Insoluto  + Var_Diferencia
						WHERE	NumTransaccion  = Aud_NumTransaccion
						  AND	Tmp_Consecutivo = Var_Contador;
					SET Var_MontoCuotaUlt   := Var_MontoCuotaGral - Var_Diferencia;
				END IF;

				-- SE ACTUALIZAN LOS VALORES  EN LA TABLA DE AYUDA CON LOS VALORES RECALCULADOS POR EL AJUSTE DE LA ULTIMA CUOTA
				UPDATE TMPARRENDAPAGOSIM SET
					Tmp_PagoTotal	= Tmp_Renta + ROUND(Tmp_Renta * Var_IVA, 2) + Tmp_MontoSeg + Tmp_MontoSegVida + ROUND(Var_MontoSeg * Var_IVA,2) +  ROUND(Var_MontoSegVida * Var_IVA,2),
					Tmp_Iva			= ROUND(Tmp_Renta * Var_IVA, 2)
					WHERE	NumTransaccion  = Aud_NumTransaccion
					  AND	Tmp_Consecutivo = Var_Contador;
			END IF;
			SET Var_Contador    := Var_Contador + Entero_Uno;
		END WHILE;

		-- Si se especifico que se dara la renta anticipada, se marcara la primera cuota como pagada y se adelantaran las fechas de las cuotas siguientes
		IF Par_RentaAnticipada = Var_RentaAntSi THEN
			CALL ARRCALCTBLPAGOANTICIPADOPRO(	Salida_No,			Par_NumErr,			Par_ErrMen,		Aud_EmpresaID,	Aud_Usuario,
												Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);
			IF (Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		/* Si se especifico que se daran rentas adelantadas, se marcara las primera (o ultimas) cuotas como pagadas. Se sabe si son las primeras o las ultimas
		cuotas dependiendo de lo que venga en el parametro Par_Adelanto */
		IF Par_RentasAdelantadas > Entero_Cero THEN
			CALL ARRCALCTBLPAGOSADELANTADOSPRO(	Par_RentasAdelantadas,	Par_Adelanto,		Salida_No,			Par_NumErr,			Par_ErrMen,
												Aud_EmpresaID,			Aud_Usuario ,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
												Aud_Sucursal,			Aud_NumTransaccion);
			IF (Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Var_NumeroCuotas    := (SELECT MAX(Tmp_Consecutivo)  FROM TMPARRENDAPAGOSIM  WHERE   NumTransaccion  = Aud_NumTransaccion);
		SET Var_FechaPrimerVen  := (SELECT Tmp_FecFin            FROM TMPARRENDAPAGOSIM  WHERE   NumTransaccion  = Aud_NumTransaccion  AND    Tmp_Consecutivo = Entero_Uno);
		SET Var_FechaUltimoVen  := (SELECT Tmp_FecFin            FROM TMPARRENDAPAGOSIM  WHERE   NumTransaccion  = Aud_NumTransaccion  AND    Tmp_Consecutivo = Var_NumeroCuotas);

		IF(Var_MontoCuotaUlt > Var_MontoCuotaGral)THEN
			SET Var_MontoCuota  := Var_MontoCuotaUlt;
		ELSE
			SET Var_MontoCuota  := Var_MontoCuotaGral;
		END IF;

		SELECT	SUM(Tmp_Capital),   SUM(Tmp_Interes),   SUM(Tmp_Iva),   SUM(Tmp_Renta),     SUM(Tmp_PagoTotal)
		  INTO	Var_TotalCapital,   Var_TotalInteres,   Var_TotalIva,   Var_TotalRenta,     Var_TotalPago
			FROM TMPARRENDAPAGOSIM
			WHERE	NumTransaccion  = Aud_NumTransaccion ;


		SET Par_NumErr          := 000;
		SET Var_Control         := 'fechaActual';
		SET Par_ErrMen          := 'El calendario se ejecuto correctamente';

		SET Par_NumTransacSim   := Aud_NumTransaccion;
		SET Par_CantCuota       := Var_MontoCuota;
		SET Par_FechaPrimerVen  := Var_FechaPrimerVen;
		SET Par_FechaUltimoVen  := Var_FechaUltimoVen;

	END ManejoErrores;

		-- Se muestran los datos
	IF (Par_Salida = Salida_Si) THEN
		SELECT
			Tmp_Consecutivo,                                Tmp_Dias,                                       Tmp_FecIni,                                 Tmp_FecFin,                                 Tmp_FecExi,
			FORMAT(Tmp_Capital,2) AS Tmp_Capital,           FORMAT(Tmp_Interes,2) AS Tmp_Interes,           FORMAT(Tmp_Renta,2) AS Tmp_Renta,           FORMAT(Tmp_Iva,2) AS Tmp_Iva,               FORMAT(Tmp_Insoluto,2) AS Tmp_Insoluto,
			FORMAT(Tmp_MontoSeg,2) AS Tmp_MontoSeg,         FORMAT(Tmp_MontoSegVida,2) AS Tmp_MontoSegVida, FORMAT(Tmp_PagoTotal,2) AS Tmp_PagoTotal,   NumTransaccion,                             Var_NumeroCuotas AS NumeroCuotas,
			Var_FechaPrimerVen AS FechaPrimerVen,           Var_FechaUltimoVen AS FechaUltimoVen,           FORMAT(Var_MontoCuota,2) AS MontoCuota,     FORMAT(Var_TotalCapital,2) AS TotalCapital, FORMAT(Var_TotalInteres,2) AS TotalInteres,
			FORMAT(Var_TotalIva,2) AS  TotalIva,            FORMAT(Var_TotalRenta,2) AS TotalRenta,         FORMAT(Var_TotalPago,2) AS TotalPago,       Par_NumErr AS NumErr,                       Par_ErrMen AS ErrMen,
			FORMAT(Tmp_MontoSegIva,2) AS Tmp_MontoSegIva,   FORMAT(Tmp_MontoSegVidaIva,2) AS Tmp_MontoSegVidaIva
		FROM        TMPARRENDAPAGOSIM
		WHERE   NumTransaccion = Aud_NumTransaccion;
	END IF;

END TerminaStore$$