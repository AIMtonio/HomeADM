-- APORTDISPERSIONVAL

DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTDISPERSIONVAL`;
DELIMITER $$

CREATE PROCEDURE `APORTDISPERSIONVAL`(
# ==============================================
# ------ SP PARA VALIDAR LOS APORTACIONES ------
# ==============================================
	Par_CadenaAport      	LONGTEXT,    -- CADENA DE APORTACIONES A VALIDAR
	Par_Salida              CHAR(1),        -- Salida en Pantalla
	INOUT Par_NumErr        INT(11),       	-- Salida en Pantalla Numero de Error o Exito
	INOUT Par_ErrMen        VARCHAR(400),   -- Salida en Pantalla Mensaje de Error o Exito

	Aud_EmpresaID           INT(11),        -- Auditoria
	Aud_Usuario             INT(11),        -- Auditoria
	Aud_FechaActual         DATETIME,       -- Auditoria
	Aud_DireccionIP         VARCHAR(15),    -- Auditoria
	Aud_ProgramaID          VARCHAR(50),    -- Auditoria

	Aud_Sucursal            INT(11),        -- Auditoria
	Aud_NumTransaccion      BIGINT(20)      -- Auditoria
)
TerminaStore: BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE Entero_Cero         INT(3);
	DECLARE Salida_No           CHAR(1);
	DECLARE Salida_SI           CHAR(1);
	DECLARE Cadena_Vacia		CHAR(1);


	-- DECLARACION DE VARIABLES
	DECLARE Var_Control         VARCHAR(200);
	DECLARE Var_Sentencia		VARCHAR(10000);
    DECLARE Aux_1				INT(11);
    DECLARE Aux_2				INT(11);
    DECLARE Aux_3				INT(11);
    DECLARE Var_CuentasError	VARCHAR(10000);
    DECLARE Var_CuentaAhoID		BIGINT(12);
    DECLARE Var_NumErrores		INT(11);
    DECLARE Var_NumRenglones	INT(11);
    DECLARE Var_CadenaBenef		LONGTEXT;
    DECLARE Var_RegCadena		LONGTEXT;
    DECLARE Var_NumRegBen		INT(11);
    DECLARE Var_AmortizacionID  INT(11);
    DECLARE Var_AportacionID	INT(11);
    DECLARE Var_CuentaTranID	INT(11);
    DECLARE Var_MontoDisp		DECIMAL(18,2);
    DECLARE Var_MontoDisponible	DECIMAL(18,2);
    DECLARE Var_CadenaReg 		LONGTEXT;
	-- ASIGNACION DE CONSTANTES
	SET Entero_Cero         	:= 0;       -- Constante Cero
	SET Cadena_Vacia 			:= '';
	SET Salida_No           	:= 'N';     -- Salida No
	SET Salida_SI           	:= 'S';     -- Salida Si

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-APORTACIONESVAL');
				SET Var_Control :='SQLEXCEPTION';
			END;

		/* SE OBTIENE LA FECHA DEL SISTEMA */
	
		SET Par_NumErr := 000;
		SET Par_ErrMen := 'Aportacion Validada Exitosamente';
		SET Var_Control:= 'aportacionID';

	END ManejoErrores;
    
    DELETE FROM TMPAPORTDISPERSION WHERE NumTransaccion = Aud_NumTransaccion;

	SELECT LENGTH(Par_CadenaAport) - LENGTH(REPLACE(Par_CadenaAport,'[',Cadena_Vacia)) + 1 INTO Var_NumRenglones;
    SET Aux_1 := 2;
    SET Var_CuentasError := CONCAT('Las siguientes cuentas: ');
    SET Var_NumErrores := 0;
    
    WHILE Aux_1 <= Var_NumRenglones DO
		
		SET Var_CadenaBenef := (SELECT TRIM(FNSPLIT_STRING(Par_CadenaAport,'[',Aux_1)));
		SET Var_CadenaBenef := (SELECT IF(Var_CadenaBenef = Cadena_Vacia,NULL,Var_CadenaBenef));
		SET Var_CadenaBenef := REPLACE(Var_CadenaBenef,']',',');
		
		
		SET Aux_3 := 1;
		SET Var_RegCadena := Cadena_Vacia;
		SET Var_CadenaReg := Cadena_Vacia;

		WHILE Aux_3 <= 3 DO 

			SET Var_RegCadena := (SELECT TRIM(FNSPLIT_STRING(Var_CadenaBenef,',',Aux_3)));
			SET Var_RegCadena := (SELECT IF(Var_RegCadena = Cadena_Vacia,NULL,Var_RegCadena));
			IF(Var_CadenaReg = Cadena_Vacia) THEN 
			
					SET Var_CadenaReg := CONCAT(Var_RegCadena);
			ELSE
					SET Var_CadenaReg := CONCAT(Var_CadenaReg,',',Var_RegCadena);
			END IF;
			
			SET Aux_3 := Aux_3 +1;

		END WHILE;

				
		SET Var_RegCadena := CONCAT(Var_CadenaReg,',',Aud_NumTransaccion);
        SET Var_Sentencia := CONCAT('INSERT INTO TMPAPORTDISPERSION VALUES(');
        SET Var_Sentencia := CONCAT(Var_Sentencia,Var_RegCadena,') ');
        SET Var_Sentencia := CONCAT(Var_Sentencia, '; ');
	
		SET @Sentencia := (Var_Sentencia);
		PREPARE APORTDISPERSGRID FROM @Sentencia;
		EXECUTE APORTDISPERSGRID;
		DEALLOCATE PREPARE APORTDISPERSGRID;

        SET Aux_1 := Aux_1 + 1;
    END WHILE;
    
		SET Var_NumRegBen := (SELECT COUNT(*) FROM TMPAPORTDISPERSION WHERE NumTransaccion =  Aud_NumTransaccion ) ;
        SET Aux_2 := 0;
        
        WHILE Aux_2 < Var_NumRegBen DO 


   			SELECT	 AportacionID,		 AmortizacionID, 		CuentaTranID
   		 		INTO Var_AportacionID,	 Var_AmortizacionID, 	Var_CuentaTranID
			FROM TMPAPORTDISPERSION 
			WHERE NumTransaccion =  Aud_NumTransaccion LIMIT Aux_2,1;


            
			SELECT CuentaAhoID INTO Var_CuentaAhoID 
					FROM APORTDISPERSIONES 
					WHERE AportacionID = Var_AportacionID 
						AND AmortizacionID =  Var_AmortizacionID;


			SELECT MontoDispersion INTO Var_MontoDisp 
					FROM APORTBENEFICIARIOS 
					WHERE AportacionID = Var_AportacionID 
						AND AmortizacionID =  Var_AmortizacionID 
						AND CuentaTranID = Var_CuentaTranID;

            
            SELECT 	ROUND(SaldoDispon,2) INTO Var_MontoDisponible
				FROM CUENTASAHO ca,	MONEDAS		mon
				WHERE	ca.CuentaAhoID	  	=  Var_CuentaAhoID
				  AND 	mon.MonedaId 	    = ca.MonedaID;


           IF(Var_MontoDisp > Var_MontoDisponible) THEN
				SET Var_CuentasError := CONCAT(Var_CuentasError,Var_CuentaAhoID,' ,');
                SET Var_NumErrores  := Var_NumErrores + 1;
            END IF;
            
            SET Aux_2 := Aux_2 +1;
        END WHILE;
			
        IF( Var_NumErrores > 0) THEN 
			SET Var_CuentasError = CONCAT(Var_CuentasError,' no cuentan con el saldo suficiente para su dispersion.');
            
			 SET Par_NumErr := 001;
			 SET Par_ErrMen := LEFT(Var_CuentasError,400);
			 SET Var_Control:= 'aportacionID';
             
		ELSE
			 SET Par_NumErr := 000;
			 SET Par_ErrMen := 'Aportacion Validada Exitosamente';
			 SET Var_Control:= 'aportacionID';
        END IF;
        
        DELETE FROM TMPAPORTDISPERSION WHERE NumTransaccion = Aud_NumTransaccion;

		IF (Par_Salida = Salida_SI) THEN
			SELECT Par_NumErr	AS NumErr,
					Par_ErrMen  AS ErrMen,
					Var_Control AS Control,
					Entero_Cero  AS Consecutivo;
		END IF;
END TerminaStore$$