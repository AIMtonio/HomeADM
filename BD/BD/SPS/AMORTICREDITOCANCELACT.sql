-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AMORTICREDITOCANCELACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `AMORTICREDITOCANCELACT`;DELIMITER $$

CREATE PROCEDURE `AMORTICREDITOCANCELACT`(
    /* SP PARA RECALCULAR LOS INTERESES CON REFINANCIAMIENTO EN LAS CANCELACIÓN DE MINISTRACIONES */
    Par_CreditoID				BIGINT(12),				# Numero de Credito
    Par_Salida                  CHAR(1),                /* Indica si hay una salida o no */
    INOUT   Par_NumErr          INT(11),

    INOUT   Par_ErrMen          VARCHAR(400),
    Aud_EmpresaID               INT(11),				-- Parametros de auditoria
    Aud_Usuario                 INT(11),
    Aud_FechaActual             DATETIME,
    Aud_DireccionIP             VARCHAR(15),

    Aud_ProgramaID              VARCHAR(50),
    Aud_Sucursal                INT(11),
    Aud_NumTransaccion          BIGINT(11)
	)
TerminaStore: BEGIN

    /* Declaracion de constantes */
    DECLARE Decimal_Cero            DECIMAL(12,2);
    DECLARE Entero_Cero             INT;
    DECLARE Entero_Negativo         INT;
    DECLARE Cadena_Vacia            CHAR(1);
    DECLARE Var_SI                  CHAR(1);
    DECLARE Var_No                  CHAR(1);
    DECLARE Var_Capital             CHAR(1);
    DECLARE Var_Interes             CHAR(1);
    DECLARE Var_CapInt              CHAR(1);
    DECLARE ComApDeduc              CHAR(1);
    DECLARE ComApFinan              CHAR(1);
    DECLARE Fecha_Vacia				DATE;

    /* Declaracion de Variables */
    DECLARE Contador                INT(11);
    DECLARE Consecutivo             INT(11);
    DECLARE ContadorInt             INT(11);
    DECLARE ContadorCap             INT(11);
    DECLARE FechaInicio             DATE;
    DECLARE FechaFinal              DATE;
    DECLARE FechaInicioInt          DATE;
    DECLARE FechaFinalInt           DATE;
    DECLARE Var_Cuotas              INT(11);
    DECLARE Var_CuotasInt           INT(11);
    DECLARE Capital                 DECIMAL(12,2);
    DECLARE Interes                 DECIMAL(12,4);
    DECLARE IvaInt                  DECIMAL(12,4);
    DECLARE Subtotal                DECIMAL(12,2);
    DECLARE Insoluto                DECIMAL(12,2);
    DECLARE Var_IVA                 DECIMAL(12,4);
    DECLARE Fre_DiasAnio            INT(11);
    DECLARE Fre_Dias                INT(11);
    DECLARE Fre_DiasInt             INT(11);
    DECLARE Var_ProCobIva           CHAR(1);
    DECLARE Var_CtePagIva           CHAR(1);
    DECLARE Var_PagaIVA             CHAR(1);
    DECLARE CapInt                  CHAR(1);
    DECLARE Var_InteresAco          DECIMAL(12,4);
    DECLARE Var_CAT                 DECIMAL(18,4);
    DECLARE Par_FechaVenc           DATE;
    DECLARE MtoSinComAp             DECIMAL(12,2);
    DECLARE CuotaSinIva             DECIMAL(12,2);
    DECLARE NumPag                  INT(11);
    DECLARE Var_Control				VARCHAR(100);		# Variable de control
    DECLARE Var_TotalCap			DECIMAL(14,2);
    DECLARE Var_TotalInt			DECIMAL(14,2);
    DECLARE Var_TotalIva			DECIMAL(14,2);
    # SEGUROS
    DECLARE Var_SeguroCuota			DECIMAL(12,2);		# Monto que cobra por seguro por cuota
    DECLARE Var_IVASeguroCuota		DECIMAL(12,2);		# Monto que cobrara por IVA
    DECLARE Var_TotalSeguroCuota	DECIMAL(12,2);		# Total de seguro cuota
    DECLARE Var_TotalIVASeguroCuota	DECIMAL(12,2);		# Total de iva seguro cuota
	DECLARE Var_FechaSistema    	DATE;
    DECLARE Var_MontoMinistrado		DECIMAL(18,2);		# Monto Ministrado
    DECLARE Var_MontoPagado			DECIMAL(14,2);		# Monto Pagado
    DECLARE Var_TasaCred			DECIMAL(12,2);		# Tasa Fija
    DECLARE Var_ProductoCredID		INT(11);
    DECLARE Var_ClienteID			INT(11);

    DECLARE Esta_Pagado     		CHAR(1);
	DECLARE Esta_Activo     		CHAR(1);
	DECLARE Esta_Vencido    		CHAR(1);
	DECLARE Esta_Vigente    		CHAR(1);


	DECLARE Var_MontoMinistra		DECIMAL(18,2);		# Monto Ministrar
    DECLARE Var_FechaMinistra		DATE;				# Fecha Ministracion
    DECLARE Var_FechaInicio			DATE;				# Fecha de Inicio de la Amortizacion
    DECLARE Var_FechaFin 			DATE;				# Fecha de Fin de la Amortizacion
    DECLARE Var_FechaCorte			DATE;				# Fecha de Corte

    DECLARE Var_Dias				INT(11);
    DECLARE Var_InteresCalculado	DECIMAL(18,2);		# Interes Calculado
    DECLARE Var_InteresAcumulado	DECIMAL(18,2);		# Interes Acumulado
    DECLARE Var_InteresTotal		DECIMAL(18,2);		# Interes Total
	DECLARE Var_NumAmorti			INT(11);
    DECLARE Var_MontoInsoluto		DECIMAL(18,2);		# Monto Insoluto
    DECLARE Var_MesFechaInicio		INT(11);			# Mes de la fecha de inicio
    DECLARE Var_MesFechaCorte		INT(11);			# Mes de la fecha de corte
    DECLARE Var_MesFechaMinistra	INT(11);			# Mes de la fecha de Ministracion
    DECLARE Var_NumeroAmorPend		INT(11);			# Numero pendiente de amortizaciones

    DECLARE Var_FinMesAmor			DATE;

    -- asignacion de constantes
    SET Decimal_Cero            := 0.00;
    SET Entero_Cero             := 0;
    SET Entero_Negativo         := -1;
    SET Cadena_Vacia            := '';
    SET Var_SI                  := 'S';
    SET Var_No                  := 'N';
    SET Var_Capital             := 'C';
    SET Var_Interes             := 'I';
    SET Var_CapInt              := 'G';
    SET ComApDeduc              :='D';
    SET ComApFinan              :='F';
    SET Fecha_Vacia				:= '1900-01-01';

    -- declaracion de variables
    SET Contador                := 1;
    SET ContadorInt             := 1;
    SET Var_CAT                 := 0.00;
    SET MtoSinComAp             := 0.00;
    SET CuotaSinIva             := 0;
    SET Esta_Pagado     := 'P';             	-- Estatus del Credito: Pagado
	SET Esta_Activo     := 'A';             	-- Estatus: Activo
	SET Esta_Vencido    := 'B';             	-- Estatus del Credito: Vencido
	SET Esta_Vigente    := 'V';             	-- Estatus del Credito: Vigente

    ManejoErrores:BEGIN     #bloque para manejar los posibles errores no controlados del codigo
       DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            SET Par_NumErr    := 999;
            SET Par_ErrMen    := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
            'Disculpe las molestias que esto le ocasiona. Ref: SP-AMORTICREDITOCANCELACT');
            SET Var_Control := 'SQLEXCEPTION';
        END;


        SELECT	C.TasaFija,		C.ProductoCreditoID,	C.ClienteID
        INTO  	Var_TasaCred,   Var_ProductoCredID,    Var_ClienteID
        FROM CREDITOS C WHERE CreditoID = Par_CreditoID;

        SET Var_IVA                 := (SELECT IVA FROM SUCURSALES WHERE SucursalID = Aud_Sucursal);
        SELECT 	FechaSistema, 		DiasCredito
	I		INTO 	Var_FechaSistema, 	Fre_DiasAnio
		FROM PARAMETROSSIS;

		SET Var_ProCobIva			:= (SELECT CobraIVAInteres FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Var_ProductoCredID);


        SELECT PagaIVA INTO Var_CtePagIva
            FROM CLIENTES
            WHERE ClienteID = Var_ClienteID;


        IF(IFNULL(Var_CtePagIva, Cadena_Vacia)) = Cadena_Vacia THEN
            SET Var_CtePagIva     := Var_Si;
        END IF;

        IF (Var_ProCobIva = Var_Si) THEN
            IF (Var_CtePagIva = Var_Si) THEN
                SET Var_PagaIVA        := Var_Si;
            END IF;
        ELSE
            SET Var_PagaIVA        := Var_No;
        END IF;


       SET Var_MontoMinistrado := (SELECT IFNULL(SUM(M.Capital), Decimal_Cero)
								   FROM MINISTRACREDAGRO M
								   WHERE M.CreditoID = Par_CreditoID
                                   AND M.Estatus = 'D' );

		SET Var_MontoPagado := (SELECT IFNULL(SUM(A.Capital), Decimal_Cero)
								FROM AMORTICREDITOAGRO A
								WHERE A.CreditoID = Par_CreditoID
                                AND A.Estatus = 'P');


        #  Al inicio, el saldo Insoluto será el monto ministrado de la primera ministracion
		SET Insoluto := IFNULL((Var_MontoMinistrado - Var_MontoPagado), Decimal_Cero);
        SET Var_MontoInsoluto := Insoluto;

        SET Contador :=(SELECT MIN(A.AmortizacionID)
            FROM AMORTICREDITOAGRO A
            WHERE CreditoID = Par_CreditoID
            AND Estatus = 'V');



        SELECT MAX(A.AmortizacionID) INTO ContadorInt
            FROM AMORTICREDITOAGRO A
            WHERE CreditoID = Par_CreditoID
            AND Estatus = 'V';

		SET Var_InteresCalculado := IFNULL(Var_InteresCalculado, Decimal_Cero);
        SET Var_InteresAcumulado := IFNULL(Var_InteresAcumulado, Decimal_Cero);
        SET Var_InteresTotal	 := IFNULL(Var_InteresTotal, Decimal_Cero);
        SET Interes				 := IFNULL(Interes, Decimal_Cero);
        SET Var_InteresAco		 := IFNULL(Var_InteresAco, Decimal_Cero);
        SET Var_MontoInsoluto	 := IFNULL(Var_MontoInsoluto, Decimal_Cero);

        WHILE (Contador <= ContadorInt) DO


			SET Var_InteresCalculado := Decimal_Cero;
			SET Var_InteresAcumulado := Decimal_Cero;
			SET Var_InteresTotal	 := Decimal_Cero;
			SET Interes				 := Decimal_Cero;
			SET Var_InteresAco		 := Decimal_Cero;


        SELECT		Amo.Capital,		Amo.FechaInicio,			Amo.FechaVencim
             INTO 	 	Capital, 		 	Var_FechaInicio,	Var_FechaFin
                FROM AMORTICREDITOAGRO Amo,
                CREDITOS	 Cre
                 WHERE AmortizacionID = Contador
                   AND Amo.CreditoID   = Cre.CreditoID
		  AND Cre.CreditoID   = Par_CreditoID
		  AND (Cre.Estatus    = Esta_Vigente  OR Cre.Estatus = Esta_Vencido)
		  AND Amo.Estatus	  = Esta_Vigente
        AND Amo.FechaExigible > Var_FechaSistema
		ORDER BY FechaExigible;

             SET Var_NumAmorti := (SELECT MIN(Numero)
             FROM MINISTRACREDAGRO M
             WHERE M.CreditoID = Par_CreditoID
             AND M.Estatus = 'I');

			# Se obtiene la fecha de corte
            SET Var_FechaCorte 	:= Var_FechaFin;
            SET Var_FechaCorte 	:= (SELECT LAST_DAY(Var_FechaInicio));
            WHILE (Var_FechaInicio< Var_FechaFin) DO

				# Se consulta si existen ministraciones en el rango de fechas.

				SELECT IFNULL(M.Capital,Decimal_Cero), M.FechaPagoMinis
						INTO Var_MontoMinistra , Var_FechaMinistra
							FROM MINISTRACREDAGRO M
							WHERE  M.CreditoID = Par_CreditoID
                            AND M.Numero = Var_NumAmorti
                            AND M.Estatus != 'C';

				SET Var_FechaMinistra := IFNULL(Var_FechaMinistra, Fecha_Vacia);


                IF (Var_FechaCorte >= Var_FechaFin) THEN
					SET Var_FechaCorte := Var_FechaFin;
				ELSE
					 SET Var_FechaCorte := Var_FechaCorte;
				 END IF;


                # Si la fecha de ministracion es mayor a la fecha de inicio y la fecha de ministracion es menor a la fecha de corte-
               IF(Var_FechaMinistra >= Var_FechaInicio AND Var_FechaMinistra < Var_FechaCorte) THEN

                   # Si la fecha de ministracion es igual a la fecha de inicio.
					IF(Var_FechaMinistra = Var_FechaInicio) THEN
						SET Insoluto := Insoluto + Var_MontoMinistra;
                        SET Var_MontoInsoluto := Var_MontoInsoluto + Var_MontoMinistra;
                        SET Var_NumAmorti = Var_NumAmorti +1;

                    ELSE

						# Si la fecha de ministracion no es igual a la fecha de inicio.
						SET Var_FechaCorte := (SELECT DATE_SUB(Var_FechaMinistra,INTERVAL 1 DAY));
						SET Insoluto := Insoluto;
                        SET Var_MontoInsoluto := Var_MontoInsoluto;

                    END IF;

				ELSE
                # Si no hay ministraciones
					SET Var_FechaCorte := Var_FechaCorte;
                    SET Insoluto := Insoluto;
                    SET Var_MontoInsoluto := Var_MontoInsoluto;
				END IF;

                SET Var_MesFechaInicio := (SELECT MONTH (Var_FechaInicio));
				SET Var_MesFechaCorte  := (SELECT MONTH (Var_FechaCorte));
                SET Var_MesFechaMinistra := (SELECT MONTH (Var_FechaMinistra));
                SET Var_FinMesAmor	:= (SELECT LAST_DAY(Var_FechaCorte));

                IF(Var_FechaCorte = Var_FechaFin) THEN
					 SET Var_Dias := IFNULL((DATEDIFF(Var_FechaCorte,Var_FechaInicio)),Entero_Cero);
                ELSE
					 SET Var_Dias := IFNULL((DATEDIFF(Var_FechaCorte,Var_FechaInicio)),Entero_Cero)+1;
                END IF;

				# Si ocurre una ministracion
                IF(Var_FechaInicio = Var_FechaMinistra) THEN

                    SET Interes        := (((Var_MontoInsoluto+Var_InteresAcumulado) * Var_TasaCred * Var_Dias ) / (Fre_DiasAnio*100))+Var_InteresAco;
					SET Var_InteresCalculado := Interes;

                    IF(Var_FechaCorte = Var_FinMesAmor ) THEN
						 SET Var_InteresAcumulado := Var_InteresTotal + Interes;
                    ELSE

						IF(Var_FechaCorte<Var_FinMesAmor) THEN
							IF(Var_FechaCorte = Var_FechaFin )THEN
								SET Var_InteresAcumulado := Var_InteresTotal + Interes;
                            ELSE
								SET Var_InteresAcumulado := Decimal_Cero;
                            END IF;

                         ELSE
							 SET Var_InteresAcumulado := Var_InteresTotal + Interes;
                         END IF;
                    END IF;

					SET Var_InteresTotal := (Var_InteresTotal + Interes);


                    # Si la fecha de corte es un dia antes de la ministracion y ocurre una ministracion entre la fecha de inicio y la fecha de corte
				ELSEIF((Var_FechaCorte = ( DATE_SUB(Var_FechaMinistra,INTERVAL 1 DAY))) AND (Var_MesFechaCorte = Var_MesFechaMinistra)) THEN

                        SET Interes        := (((Var_MontoInsoluto+Var_InteresAcumulado) * Var_TasaCred * Var_Dias ) / (Fre_DiasAnio*100))+Var_InteresAco;
						SET Var_InteresCalculado := Interes;
                        SET Var_InteresTotal := (Var_InteresTotal + Interes);
						SET Var_InteresAcumulado := Var_InteresAcumulado; # El interes acumulado sera el acumulado del mes anterior sin sumarle los intereses




                    # Si no hay ministraciones
					ELSE

						SET Interes   := (((Var_MontoInsoluto+Var_InteresAcumulado) * Var_TasaCred * Var_Dias ) / (Fre_DiasAnio*100))+Var_InteresAco;
						SET Var_InteresCalculado := Interes;
                        SET Var_InteresTotal := (Var_InteresAcumulado + Interes);
						SET Var_InteresAcumulado := Var_InteresAcumulado  + Interes;

                END IF;

                # Se obtiene el mes de la fecha corte
                SET Var_MesFechaCorte  := (SELECT MONTH (Var_FechaCorte));

                # Numero de ministraciones pendientes por desembolsar en el mismo mes
				SELECT COUNT(M.Numero)
						INTO Var_NumeroAmorPend
							FROM MINISTRACREDAGRO M
							WHERE  M.CreditoID = Par_CreditoID
                            AND M.Numero >= Var_NumAmorti
                            AND MONTH(M.FechaPagoMinis)=Var_MesFechaCorte
                            AND M.Estatus != 'C'
                            AND M.FechaPagoMinis<Var_FechaFin;

                # Fecha de la primera ministracion pendiente en el mismo mes
                 SELECT  MIN(M.FechaPagoMinis)
						INTO  Var_FechaMinistra
							FROM MINISTRACREDAGRO M
							WHERE  M.CreditoID = Par_CreditoID
                            AND M.Numero >= Var_NumAmorti
                            AND MONTH(M.FechaPagoMinis)=Var_MesFechaCorte
                             AND M.Estatus != 'C'
                            AND M.FechaPagoMinis<Var_FechaFin;

				SET Var_FechaMinistra := IFNULL(Var_FechaMinistra, Fecha_Vacia);

				SET Var_FechaInicio := (SELECT DATE_ADD(Var_FechaCorte,INTERVAL 1 DAY));

				# Si elnumero de ministraciones pendientes es mayor a uno
                IF(Var_NumeroAmorPend > 1) THEN
					SET Var_FechaCorte 	:= (SELECT DATE_ADD(Var_FechaMinistra,INTERVAL 1 DAY));

				ELSE
					 SET Var_FechaCorte 	:= (SELECT LAST_DAY(Var_FechaInicio));

                END IF;

				IF (Var_FechaCorte > Var_FechaFin) THEN
					SET Var_FechaCorte := Var_FechaFin;

				ELSE
					 SET Var_FechaCorte := Var_FechaCorte;

				END IF;

            END WHILE;

            SET Interes = Var_InteresAcumulado;
            IF (Var_PagaIVA = Var_Si) THEN
                SET IvaInt    := Interes * Var_IVA;
            ELSE
                SET IvaInt := Decimal_Cero;
            END IF;

            SET Subtotal    := Capital + Interes + IvaInt;
            SET Insoluto    := Insoluto - Capital;
			SET Var_MontoInsoluto    := Var_MontoInsoluto - Capital;

            SET CuotaSinIva := Capital + Interes;


            UPDATE AMORTICREDITOAGRO SET
                Interes    = Interes,
                IVAInteres        = IvaInt
            WHERE AmortizacionID = Contador
            AND CreditoID = Par_CreditoID;


            SET Contador = Contador+1;
        END WHILE;

        SET Par_NumErr    := 0;
        SET Par_ErrMen    := 'Simulacion Exitosa';

    END ManejoErrores;

	IF(Par_Salida = Var_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Cadena_Vacia AS Control,
				Entero_Cero AS Consecutivo;
	END IF;

END TerminaStore$$