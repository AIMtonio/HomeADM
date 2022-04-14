DELIMITER ;
DROP PROCEDURE IF EXISTS DIFERSIMCALENDARIOPRO;

DELIMITER $$
CREATE PROCEDURE `DIFERSIMCALENDARIOPRO`(
	Par_CreditoID					BIGINT,
	Par_AmortInicio					INT,
	Par_AmortFin					INT,
	Par_NumMeses					INT,
	Par_TipoDiferimiento 			CHAR(1),

	Par_Salida						CHAR(1),					# Indica el tipo de salida S.- SI N.- No
	INOUT Par_NumErr				INT,						# Numero de Error
	INOUT Par_ErrMen				VARCHAR(400),				# Mensaje de Error
	/*Parametros de Auditoria*/
	Aud_EmpresaID					INT(11),
	Aud_Usuario						INT(11),
	Aud_FechaActual					DATETIME,
	Aud_DireccionIP					VARCHAR(15),
	Aud_ProgramaID					VARCHAR(50),
	Aud_Sucursal					INT(11),
	Aud_NumTransaccion				BIGINT(12)
)
TerminaStore:BEGIN

declare Var_FechaIncio				DATE;
declare Var_FechaFin				DATE;
declare Var_FechaExigible			DATE;
declare Var_AmortActual				INT;

DECLARE Var_FrecuenciaCap			CHAR(1);
DECLARE Var_FrecuenciaInt			CHAR(1);
DECLARE Var_TipoPagoCapital			CHAR(1);
DECLARE Var_FechaInhabil			CHAR(1);
DECLARE Var_CalendIrregular			CHAR(1);
DECLARE Var_DiaPagoInteres			CHAR(1);
DECLARE Var_DiaPagoCapital			CHAR(1);
DECLARE Var_DiaMesInteres			INT;
DECLARE Var_DiaMesCapital			INT;
DECLARE Var_AjusFecUlVenAmo			CHAR(1);
DECLARE Var_AjusFecExiVen			CHAR(1);
DECLARE Var_FechaIniAmor			DATE;
DECLARE Var_Estatus					CHAR(1);

DECLARE Var_MontoCapital			DECIMAL(16,2);
DECLARE Var_MontoInteres			DECIMAL(16,2);

declare Difer_Completo				CHAR(1);
declare Difer_Unico					CHAR(1);
DECLARE PagoSemanal                             CHAR(1);    -- Pago Semanal (S)
DECLARE PagoDecenal                             CHAR(1);    -- Pago Decenal (D)
DECLARE PagoCatorcenal                          CHAR(1);    -- Pago Catorcenal (C)
DECLARE PagoQuincenal                           CHAR(1);    -- Pago Quincenal (Q)
DECLARE PagoMensual                             CHAR(1);    -- Pago Mensual (M)
DECLARE PagoPeriodo                             CHAR(1);    -- Pago por periodo (P)
DECLARE PagoBimestral                           CHAR(1);    -- PagoBimestral (B)
DECLARE PagoTrimestral                          CHAR(1);    -- PagoTrimestral (T)
DECLARE PagoTetrames                            CHAR(1);    -- PagoTetraMestral (R)
DECLARE PagoSemestral                           CHAR(1);    -- PagoSemestral (E)
DECLARE PagoAnual                               CHAR(1);    -- PagoAnual (A)
DECLARE PagoUnico                               CHAR(1);    -- Pago Unico (U)

declare Pagos_Crecientes						CHAR(1);
declare Pagos_Iguales							CHAR(1);
declare Pagos_Libres							CHAR(1);
declare Fin_Mes									CHAR(1);
declare Decimal_Cero							DECIMAL(16,2);
declare Salida_SI								CHAR(1);

SET Difer_Completo					:= 'C';
SET Difer_Unico						:= 'U';
SET Pagos_Crecientes				:= 'C';
SET Pagos_Iguales					:= 'I';
SET Pagos_Libres					:= 'L';
SET PagoSemanal                 	:= 'S'; -- PagoSemanal
SET PagoDecenal                	 	:= 'D'; -- Pago Decenal
SET PagoCatorcenal              	:= 'C'; -- PagoCatorcenal
SET PagoQuincenal               	:= 'Q'; -- PagoQuincenal
SET PagoMensual                 	:= 'M'; -- PagoMensual
SET PagoPeriodo                 	:= 'P'; -- PagoPeriodo
SET PagoBimestral               	:= 'B'; -- PagoBimestral
SET PagoTrimestral              	:= 'T'; -- PagoTrimestral 
SET PagoTetrames                	:= 'R'; -- PagoTetraMestral
SET PagoSemestral               	:= 'E'; -- PagoSemestral
SET PagoAnual                  	 	:= 'A'; -- PagoAnual
SET PagoUnico                  	 	:= 'U'; -- Unico
SET Fin_Mes                  	 	:= 'F'; -- Unico
SET Decimal_Cero					:= 0;
SET Salida_SI						:= 'S';


ManejoErrores:BEGIN

SET Var_AmortActual := Par_AmortInicio;

select 	FrecuenciaCap,		FrecuenciaInt,			TipoPagoCapital,		FechaInhabil,		CalendIrregular,
		DiaPagoInteres,		DiaPagoCapital,			DiaMesInteres,			DiaMesCapital,		AjusFecUlVenAmo,
        AjusFecExiVen
INTO 	Var_FrecuenciaCap,	Var_FrecuenciaInt,		Var_TipoPagoCapital,	Var_FechaInhabil,	Var_CalendIrregular,
		Var_DiaPagoInteres,	Var_DiaPagoCapital,		Var_DiaMesInteres,		Var_DiaMesCapital,	Var_AjusFecUlVenAmo,
        Var_AjusFecExiVen
 from CREDITOS where CreditoID = Par_CreditoID;



WHILE Par_AmortInicio <= Par_AmortFin DO
CicloCalendario:BEGIN

	SELECT FechaInicio,		FechaVencim,		FechaExigible,			Capital,			Interes,			Estatus
    INTO Var_FechaIncio,	Var_FechaFin,		Var_FechaExigible,		Var_MontoCapital,	Var_MontoInteres,	Var_Estatus
    FROM AMORTICREDITO
    WHERE CreditoID = Par_CreditoID
    AND AmortizacionID = Par_AmortInicio;
    
    SET Var_FechaIniAmor := Var_FechaIncio;
    
    IF Var_Estatus NOT IN ('V','A','B') THEN
		LEAVE CicloCalendario;
    END IF;
	
    -- -------------------------------------------
    -- SECCION DE PAGOS LIBRES
    -- -------------------------------------------
    IF Var_TipoPagoCapital = Pagos_Libres THEN
			SET Var_FechaIncio  := DATE_ADD(Var_FechaIncio,INTERVAL Par_NumMeses MONTH);
			SET Var_FechaFin 	:= DATE_ADD(Var_FechaFin,INTERVAL Par_NumMeses MONTH);
			SET Var_FechaExigible := FNSUMDIASHABIL(Var_FechaFin,0);
    END IF;
    
    
    -- -------------------------------------------
    -- SECCION DE PAGOS DE CAPITAL CRECIENTES
    -- -------------------------------------------
    IF Var_TipoPagoCapital = Pagos_Crecientes THEN
    
			IF Var_FrecuenciaCap IN (PagoSemanal,PagoCatorcenal) AND Var_FrecuenciaInt =  Var_FrecuenciaCap THEN
				SET Var_FechaIncio  := DATE_ADD(Var_FechaIncio,INTERVAL (28*Par_NumMeses) DAY);
				SET Var_FechaFin 	:= DATE_ADD(Var_FechaFin,INTERVAL (28*Par_NumMeses) DAY);
				SET Var_FechaExigible := FNSUMDIASHABIL(Var_FechaFin,0);
			END IF;
			
			IF Var_FrecuenciaCap IN (PagoPeriodo,PagoUnico,PagoAnual) AND Var_FrecuenciaInt =  Var_FrecuenciaCap THEN
				SET Var_FechaIncio  := DATE_ADD(Var_FechaIncio,INTERVAL Par_NumMeses MONTH);
				SET Var_FechaFin 	:= DATE_ADD(Var_FechaFin,INTERVAL Par_NumMeses MONTH);
				SET Var_FechaExigible := FNSUMDIASHABIL(Var_FechaFin,0);
			END IF;
			
			IF Var_FrecuenciaCap IN (PagoMensual,PagoBimestral,PagoTrimestral,PagoTetrames,PagoSemestral) 
					AND Var_FrecuenciaInt =  Var_FrecuenciaCap 
					AND Var_DiaPagoCapital = Fin_Mes THEN
                    
                
				SET Var_FechaIncio  	:= (DATE_ADD(Var_FechaIncio,INTERVAL Par_NumMeses MONTH));
				SET Var_FechaFin 		:= (DATE_ADD(Var_FechaFin,INTERVAL Par_NumMeses MONTH));
                
                IF DAY(Var_FechaIncio) > 15 THEN
					SET Var_FechaIncio := LAST_DAY(Var_FechaIncio);
                END IF;
                
                IF DAY(Var_FechaFin) > 15 THEN
					SET Var_FechaFin := LAST_DAY(Var_FechaFin);
                END IF;
                
                
				SET Var_FechaExigible 	:= FNSUMDIASHABIL(Var_FechaFin,0);
			END IF;
			
			IF Var_FrecuenciaCap IN (PagoMensual,PagoBimestral,PagoTrimestral,PagoTetrames,PagoSemestral) 
					AND Var_FrecuenciaInt =  Var_FrecuenciaCap 
					AND Var_DiaPagoCapital <> Fin_Mes THEN
				
                
				SET Var_FechaIncio  	:= (DATE_ADD(Var_FechaIncio,INTERVAL Par_NumMeses MONTH));
				SET Var_FechaFin 		:= (DATE_ADD(Var_FechaFin,INTERVAL Par_NumMeses MONTH));
				SET Var_FechaExigible 	:= FNSUMDIASHABIL(Var_FechaFin,0);
                
			END IF;
			
			
			IF Var_FrecuenciaCap IN (PagoDecenal) 
					AND Var_FrecuenciaInt =  Var_FrecuenciaCap THEN
				
				IF DAY(Var_FechaIncio) > 26 THEN 
					SET Var_FechaIncio  	:= LAST_DAY(DATE_ADD(Var_FechaIncio,INTERVAL Par_NumMeses MONTH));
				ELSE
					SET Var_FechaIncio  	:= (DATE_ADD(Var_FechaIncio,INTERVAL Par_NumMeses MONTH));
				END IF;
				
				IF DAY(Var_FechaFin) > 26 THEN
					SET Var_FechaFin 		:= LAST_DAY(DATE_ADD(Var_FechaFin,INTERVAL Par_NumMeses MONTH));
				ELSE
					SET Var_FechaFin 		:= (DATE_ADD(Var_FechaFin,INTERVAL Par_NumMeses MONTH));
				END IF;
				
				SET Var_FechaExigible 	:= FNSUMDIASHABIL(Var_FechaFin,0);
			END IF;
			
			
			IF Var_FrecuenciaCap IN (PagoQuincenal) 
					AND Var_FrecuenciaInt 	=  Var_FrecuenciaCap 
				 	AND Var_DiaPagoCapital  = Fin_Mes
					THEN
				
				IF DAY(Var_FechaIncio) > 26 THEN 
					SET Var_FechaIncio  	:= LAST_DAY(DATE_ADD(Var_FechaIncio,INTERVAL Par_NumMeses MONTH));
				ELSE
					SET Var_FechaIncio  	:= (DATE_ADD(Var_FechaIncio,INTERVAL Par_NumMeses MONTH));
				END IF;
				
				IF DAY(Var_FechaFin) > 26 THEN
					SET Var_FechaFin 		:= LAST_DAY(DATE_ADD(Var_FechaFin,INTERVAL Par_NumMeses MONTH));
				ELSE
					SET Var_FechaFin 		:= (DATE_ADD(Var_FechaFin,INTERVAL Par_NumMeses MONTH));
				END IF;

				SET Var_FechaExigible 	:= FNSUMDIASHABIL(Var_FechaFin,0);
			END IF;
			
			
			 IF Var_FrecuenciaCap IN (PagoQuincenal) 
					AND Var_FrecuenciaInt 	=  Var_FrecuenciaCap 
					AND Var_DiaPagoCapital  <> Fin_Mes
					THEN
				SET Var_FechaIncio  	:= (DATE_ADD(Var_FechaIncio,INTERVAL Par_NumMeses MONTH));
				SET Var_FechaFin 		:= (DATE_ADD(Var_FechaFin,INTERVAL Par_NumMeses MONTH));
				SET Var_FechaExigible 	:= FNSUMDIASHABIL(Var_FechaFin,0);
			END IF;
            
            
            IF Par_TipoDiferimiento = Difer_Unico AND Var_AmortActual = Par_AmortInicio THEN
				SET Var_FechaIncio := Var_FechaIniAmor;
			END IF;
        
     END IF;
	
    
    -- -------------------------------------------
    -- SECCION DE PAGOS DE CAPITAL IGUALES
    -- -------------------------------------------
	 IF Var_TipoPagoCapital = Pagos_Iguales THEN
			
            IF Var_MontoCapital > Decimal_Cero THEN
		
				/* == SEMANAL Y CATORCENAL == */
				IF Var_FrecuenciaCap IN (PagoSemanal,PagoCatorcenal)  THEN
					SET Var_FechaIncio  := DATE_ADD(Var_FechaIncio,INTERVAL (28*Par_NumMeses) DAY);
					SET Var_FechaFin 	:= DATE_ADD(Var_FechaFin,INTERVAL (28*Par_NumMeses) DAY);
					SET Var_FechaExigible := FNSUMDIASHABIL(Var_FechaFin,0);
				END IF;
				
				
				/* == PERIODO, UNICO Y ANUAL == */
				IF Var_FrecuenciaCap IN (PagoPeriodo,PagoUnico,PagoAnual)  THEN
					SET Var_FechaIncio  := DATE_ADD(Var_FechaIncio,INTERVAL Par_NumMeses MONTH);
					SET Var_FechaFin 	:= DATE_ADD(Var_FechaFin,INTERVAL Par_NumMeses MONTH);
					SET Var_FechaExigible := FNSUMDIASHABIL(Var_FechaFin,0);
				END IF;
				
				IF Var_FrecuenciaCap IN (PagoMensual,PagoBimestral,PagoTrimestral,PagoTetrames,PagoSemestral) 
						AND Var_DiaPagoCapital = Fin_Mes THEN
					SET Var_FechaIncio  	:= (DATE_ADD(Var_FechaIncio,INTERVAL Par_NumMeses MONTH));
					SET Var_FechaFin 		:= (DATE_ADD(Var_FechaFin,INTERVAL Par_NumMeses MONTH));
                    
                    IF DAY(Var_FechaIncio) > 15 THEN
						SET Var_FechaIncio := LAST_DAY(Var_FechaIncio);
					END IF;
					
					IF DAY(Var_FechaFin) > 15 THEN
						SET Var_FechaFin := LAST_DAY(Var_FechaFin);
					END IF;
                
					SET Var_FechaExigible 	:= FNSUMDIASHABIL(Var_FechaFin,0);
				END IF;
				
				IF Var_FrecuenciaCap IN (PagoMensual,PagoBimestral,PagoTrimestral,PagoTetrames,PagoSemestral) 
						AND Var_DiaPagoCapital <> Fin_Mes THEN
					SET Var_FechaIncio  	:= (DATE_ADD(Var_FechaIncio,INTERVAL Par_NumMeses MONTH));
					SET Var_FechaFin 		:= (DATE_ADD(Var_FechaFin,INTERVAL Par_NumMeses MONTH));
					SET Var_FechaExigible 	:= FNSUMDIASHABIL(Var_FechaFin,0);
				END IF;
				
				
				IF Var_FrecuenciaCap IN (PagoDecenal)  THEN
					
					IF DAY(Var_FechaIncio) > 26 THEN 
						SET Var_FechaIncio  	:= LAST_DAY(DATE_ADD(Var_FechaIncio,INTERVAL Par_NumMeses MONTH));
					ELSE
						SET Var_FechaIncio  	:= (DATE_ADD(Var_FechaIncio,INTERVAL Par_NumMeses MONTH));
					END IF;
					
					IF DAY(Var_FechaFin) > 26 THEN
						SET Var_FechaFin 		:= LAST_DAY(DATE_ADD(Var_FechaFin,INTERVAL Par_NumMeses MONTH));
					ELSE
						SET Var_FechaFin 		:= (DATE_ADD(Var_FechaFin,INTERVAL Par_NumMeses MONTH));
					END IF;
					
					SET Var_FechaExigible 	:= FNSUMDIASHABIL(Var_FechaFin,0);
				END IF;
				
				
				IF Var_FrecuenciaCap IN (PagoQuincenal) 
					 	AND Var_DiaPagoCapital  = Fin_Mes
						THEN
					IF DAY(Var_FechaIncio) > 26 THEN 
						SET Var_FechaIncio  	:= LAST_DAY(DATE_ADD(Var_FechaIncio,INTERVAL Par_NumMeses MONTH));
					ELSE
						SET Var_FechaIncio  	:= (DATE_ADD(Var_FechaIncio,INTERVAL Par_NumMeses MONTH));
					END IF;
					
					IF DAY(Var_FechaFin) > 26 THEN
						SET Var_FechaFin 		:= LAST_DAY(DATE_ADD(Var_FechaFin,INTERVAL Par_NumMeses MONTH));
					ELSE
						SET Var_FechaFin 		:= (DATE_ADD(Var_FechaFin,INTERVAL Par_NumMeses MONTH));
					END IF;

					SET Var_FechaExigible 	:= FNSUMDIASHABIL(Var_FechaFin,0);
				END IF;
				
				
				 IF Var_FrecuenciaCap IN (PagoQuincenal) 
						AND Var_DiaPagoCapital  <> Fin_Mes
						THEN
					SET Var_FechaIncio  	:= (DATE_ADD(Var_FechaIncio,INTERVAL Par_NumMeses MONTH));
					SET Var_FechaFin 		:= (DATE_ADD(Var_FechaFin,INTERVAL Par_NumMeses MONTH));
					SET Var_FechaExigible 	:= FNSUMDIASHABIL(Var_FechaFin,0);
				END IF;
			
            END IF;
            
            
            IF Var_MontoCapital = Decimal_Cero THEN
		
				/* == SEMANAL Y CATORCENAL == */
				IF Var_FrecuenciaInt IN (PagoSemanal,PagoCatorcenal)  THEN
					SET Var_FechaIncio  := DATE_ADD(Var_FechaIncio,INTERVAL (28*Par_NumMeses) DAY);
					SET Var_FechaFin 	:= DATE_ADD(Var_FechaFin,INTERVAL (28*Par_NumMeses) DAY);
					SET Var_FechaExigible := FNSUMDIASHABIL(Var_FechaFin,0);
				END IF;
				
				
				/* == PERIODO, UNICO Y ANUAL == */
				IF Var_FrecuenciaInt IN (PagoPeriodo,PagoUnico,PagoAnual)  THEN
					SET Var_FechaIncio  := DATE_ADD(Var_FechaIncio,INTERVAL Par_NumMeses MONTH);
					SET Var_FechaFin 	:= DATE_ADD(Var_FechaFin,INTERVAL Par_NumMeses MONTH);
					SET Var_FechaExigible := FNSUMDIASHABIL(Var_FechaFin,0);
				END IF;
				
				IF Var_FrecuenciaInt IN (PagoMensual,PagoBimestral,PagoTrimestral,PagoTetrames,PagoSemestral) 
						AND Var_DiaPagoInteres = Fin_Mes THEN
					SET Var_FechaIncio  	:= (DATE_ADD(Var_FechaIncio,INTERVAL Par_NumMeses MONTH));
					SET Var_FechaFin 		:= (DATE_ADD(Var_FechaFin,INTERVAL Par_NumMeses MONTH));
                    
                    IF DAY(Var_FechaIncio) > 15 THEN
						SET Var_FechaIncio := LAST_DAY(Var_FechaIncio);
					END IF;
					
					IF DAY(Var_FechaFin) > 15 THEN
						SET Var_FechaFin := LAST_DAY(Var_FechaFin);
					END IF;
                    
					SET Var_FechaExigible 	:= FNSUMDIASHABIL(Var_FechaFin,0);
				END IF;
				
				IF Var_FrecuenciaInt IN (PagoMensual,PagoBimestral,PagoTrimestral,PagoTetrames,PagoSemestral) 
						AND Var_DiaPagoInteres <> Fin_Mes THEN
					SET Var_FechaIncio  	:= (DATE_ADD(Var_FechaIncio,INTERVAL Par_NumMeses MONTH));
					SET Var_FechaFin 		:= (DATE_ADD(Var_FechaFin,INTERVAL Par_NumMeses MONTH));
					SET Var_FechaExigible 	:= FNSUMDIASHABIL(Var_FechaFin,0);
				END IF;
				
				
				IF Var_FrecuenciaInt IN (PagoDecenal)  THEN
					
					IF DAY(Var_FechaIncio) > 26 THEN 
						SET Var_FechaIncio  	:= LAST_DAY(DATE_ADD(Var_FechaIncio,INTERVAL Par_NumMeses MONTH));
					ELSE
						SET Var_FechaIncio  	:= (DATE_ADD(Var_FechaIncio,INTERVAL Par_NumMeses MONTH));
					END IF;
					
					IF DAY(Var_FechaFin) > 26 THEN
						SET Var_FechaFin 		:= LAST_DAY(DATE_ADD(Var_FechaFin,INTERVAL Par_NumMeses MONTH));
					ELSE
						SET Var_FechaFin 		:= (DATE_ADD(Var_FechaFin,INTERVAL Par_NumMeses MONTH));
					END IF;
					
					SET Var_FechaExigible 	:= FNSUMDIASHABIL(Var_FechaFin,0);
				END IF;
				
				
				IF Var_FrecuenciaInt IN (PagoQuincenal) 
						 AND Var_DiaPagoInteres  = Fin_Mes
						THEN
					
					IF DAY(Var_FechaIncio) > 26 THEN 
						SET Var_FechaIncio  	:= LAST_DAY(DATE_ADD(Var_FechaIncio,INTERVAL Par_NumMeses MONTH));
					ELSE
						SET Var_FechaIncio  	:= (DATE_ADD(Var_FechaIncio,INTERVAL Par_NumMeses MONTH));
					END IF;
					
					IF DAY(Var_FechaFin) > 26 THEN
						SET Var_FechaFin 		:= LAST_DAY(DATE_ADD(Var_FechaFin,INTERVAL Par_NumMeses MONTH));
					ELSE
						SET Var_FechaFin 		:= (DATE_ADD(Var_FechaFin,INTERVAL Par_NumMeses MONTH));
					END IF;

					SET Var_FechaExigible 	:= FNSUMDIASHABIL(Var_FechaFin,0);
				END IF;
				
				
				 IF Var_FrecuenciaInt IN (PagoQuincenal) 
						AND Var_DiaPagoInteres  <> Fin_Mes
						THEN
					SET Var_FechaIncio  	:= (DATE_ADD(Var_FechaIncio,INTERVAL Par_NumMeses MONTH));
					SET Var_FechaFin 		:= (DATE_ADD(Var_FechaFin,INTERVAL Par_NumMeses MONTH));
					SET Var_FechaExigible 	:= FNSUMDIASHABIL(Var_FechaFin,0);
				END IF;
				
            END IF;
            
            
            
            IF Par_TipoDiferimiento = Difer_Unico AND Var_AmortActual = Par_AmortInicio THEN
				SET Var_FechaIncio := Var_FechaIniAmor;
			END IF;
        
     END IF;
    
	UPDATE AMORTICREDITO SET 
		FechaInicio = Var_FechaIncio,
        FechaVencim = Var_FechaFin,
        FechaExigible = Var_FechaExigible
    WHERE CreditoID = Par_CreditoID
    AND AmortizacionID = Par_AmortInicio;
    
END CicloCalendario;
SET Par_AmortInicio := Par_AmortInicio + 1;
END WHILE;


END ManejoErrores;

IF Par_Salida = Salida_SI THEN

	SELECT Par_NumErr as NumErr,
		   Par_ErrMen as ErrMen;
           
END IF;

END TerminaStore$$

