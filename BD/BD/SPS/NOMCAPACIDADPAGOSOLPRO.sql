-- NOMCAPACIDADPAGOSOLPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `NOMCAPACIDADPAGOSOLPRO`;
DELIMITER $$

CREATE PROCEDURE `NOMCAPACIDADPAGOSOLPRO`(
# ==============================================================================================================
# ------- STORED DE PROCESO PARA CALCULAR LA CAPACIDAD DE PAGO ---------
# ==============================================================================================================
    Par_SolicitudCreditoID		BIGINT(20),		-- Identificador de la tabla SOLICITUDCREDITO
    Par_ListaClasifClavPresup	VARCHAR(2000),	-- Lista de las claves, con sus montos

    Par_Salida    				CHAR(1),		-- Parametro de salida S= si, N= no
    INOUT Par_NumErr 			INT(11),		-- Parametro de salida numero de error
    INOUT Par_ErrMen  			VARCHAR(400),	-- Parametro de salida mensaje de error
	
    Aud_EmpresaID       		INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         		INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual     		DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     		VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      		VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        		INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  		BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)

TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
    DECLARE Var_Consecutivo				VARCHAR(100);   	-- Variable consecutivo
	DECLARE Var_Control         		VARCHAR(100);   	-- Variable de Control
    DECLARE Var_ConvenioNominaID		BIGINT(12);
    DECLARE Var_TipoCredito				CHAR(1);
    DECLARE Var_FormCapPago				VARCHAR(200);
    DECLARE Var_FormCapPagoRes			VARCHAR(200);
	DECLARE Var_FormulaAplic			VARCHAR(200);		-- Formula que se aplicara dependiendo el caso
	DECLARE Var_FormulaVerif			VARCHAR(300);		-- Formula para verificacion
    DECLARE Var_TotalReg				INT(11);			-- Total de registros obtenidos
    DEClARE Var_EjecutaFormula			VARCHAR(250);		-- Variable para almacenar la ejecucion de la formula
    DECLARE Var_PosConjunto				INT(11);			-- Variable de pos conjunto
    DECLARE Var_Conjunto				VARCHAR(50);		-- Variable de conjunto
    DECLARE Var_ClasifClavPresupID		VARCHAR(20);		-- Identificador de la clasificacion
    DECLARE Var_MontoTotal				DECIMAL(12,2);		-- Monto de las clasificaciones obtenidas de la cadena
    DECLARE Var_PosGuion				INT(11);			-- Variable de  por guion
    DECLARE Var_CapacidadPago			DECIMAL(12,2);		-- Variable para resultado de Capacidad de pago
    DECLARE Var_DesMensajeFormula		VARCHAR(200);		-- Variable para validar Error en formula
    DECLARE Var_Contador 				INT(11);			-- Contador
    DECLARE Var_CantFalt				INT(11);			-- Cantidad de clave faltantes
    
    -- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI
    DECLARE Incremental			INT(11);			-- Parametro para uso en while
    DECLARE Entero_Uno			INT(11);			-- Entero_Uno
    DECLARE DelimitComa			CHAR(1);			-- Delimitador de coma
    DECLARE DelimitGion			CHAR(1);			-- Delimitador de Guion
    DECLARE Con_DesFormulaRees	VARCHAR(200);		-- Descripción de Restructura
    DECLARE Con_DesFormulaNu	VARCHAR(200);		-- Descripción de Crédito Nuevo
    
    DECLARE FormulaAplicTMP		VARCHAR(1000);
    DECLARE PosicionText		VARCHAR(1);
    DECLARE Pattern				VARCHAR(1000);
    DECLARE IncrementaLoop		INT(10);

    -- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia        	:= '';
	SET Entero_Cero         	:= 0;
	SET Salida_SI          		:= 'S';
	SET Incremental				:= 0;
    SET Entero_Uno				:= 1;				-- Entero UNO
    SET DelimitComa				:= ',';				-- Delimitador de coma
    SET DelimitGion				:= '-';				-- Delimitador de Guion
    SET Con_DesFormulaRees		:= 'Capacidad de Pago Renovación, Reestructura o Consolidación';
    SET Con_DesFormulaNu		:= 'Capacidad de pago Crédito Nuevo';
    
    SET FormulaAplicTMP			:= '';
	SET Pattern					:= '[^A-Za-z0-9 ]';
	SET IncrementaLoop			:= 1;
    
	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-NOMCAPACIDADPAGOSOLPRO');
			SET Var_Control = 'SQLEXCEPTION';
		END;
        
        -- SE CREA TABLAS TEMPORALRES
        DROP TABLE IF EXISTS FORMAPLICTMP;
		CREATE TABLE FORMAPLICTMP(
		NomClasifClavPresup		VARCHAR(20),
		MontoTotal 				DECIMAL(12,2));
		
        DROP TABLE IF EXISTS RESULTADOTMP;
        CREATE TABLE RESULTADOTMP(
        CapacidadPago	DECIMAL(12,2));
        
		IF(IFNULL(Par_ListaClasifClavPresup,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen := 'La lista de clasificaciones esta vacia.';
			LEAVE ManejoErrores;
		END IF;
        
        -- SE OBTIENE EL CONVENIO CON LA NOMINA        
        SELECT ConvenioNominaID,TipoCredito
			INTO Var_ConvenioNominaID, Var_TipoCredito
        FROM SOLICITUDCREDITO 
			WHERE SolicitudCreditoId = Par_SolicitudCreditoID;
            
		IF(IFNULL(Var_ConvenioNominaID,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 002;
			SET Par_ErrMen := 'La solicitud especificada no tiene asignado un convenio de nomina.';
			LEAVE ManejoErrores;
		END IF;
        
        -- SE OBTIENE LA FORMULA
        SELECT FormCapPago,FormCapPagoRes
			INTO Var_FormCapPago, Var_FormCapPagoRes
        FROM CONVENIOSNOMINA 
			WHERE ConvenioNominaID = Var_ConvenioNominaID;
        
        -- SE APLICA FORMULA
        IF (Var_TipoCredito = 'N') THEN
			SET Var_FormulaAplic := Var_FormCapPago;
            SET Var_DesMensajeFormula := Con_DesFormulaNu;
            ELSE IF (Var_TipoCredito != 'N') THEN
				SET Var_FormulaAplic := Var_FormCapPagoRes;
                SET Var_DesMensajeFormula := Con_DesFormulaRees;
			END IF;
        END IF;
        
        -- Tabla temporal para registrar todas las claves presupuestales de la formula
        DROP TABLE IF EXISTS TMP_FORMULA;
		CREATE TABLE TMP_FORMULA(
			NomClasifClavPresup		VARCHAR(20)
		);
		
		SET Var_FormulaVerif := Var_FormulaAplic;
		SET Var_FormulaVerif := (SELECT REPLACE(Var_FormulaVerif, '(', ''));
		SET Var_FormulaVerif := (SELECT REPLACE(Var_FormulaVerif, ')', ''));
		SET Var_FormulaVerif := (SELECT REPLACE(Var_FormulaVerif, '+', ','));
		SET Var_FormulaVerif := (SELECT REPLACE(Var_FormulaVerif, '-', ','));
		SET Var_FormulaVerif := (SELECT REPLACE(Var_FormulaVerif, '*', ','));
		SET Var_FormulaVerif := (SELECT REPLACE(Var_FormulaVerif, '?', ','));

		SET Var_FormulaVerif := (SELECT REPLACE(Var_FormulaVerif, ',','\'),(\''));
		SET Var_FormulaVerif := CONCAT('INSERT INTO TMP_FORMULA(NomClasifClavPresup) VALUES (\'', Var_FormulaVerif, '\');');


		SET @Sentencia	:= Var_FormulaVerif;
	    PREPARE SQL_TMPFORMULA FROM @Sentencia;
	    EXECUTE SQL_TMPFORMULA;
	    DEALLOCATE PREPARE SQL_TMPFORMULA;

		-- SE RECORRE LA CADENA
        SET Var_PosConjunto := Entero_Uno;
        SELECT POSITION(DelimitComa IN Par_ListaClasifClavPresup) INTO Var_PosConjunto;        
        WHILE Var_PosConjunto > Entero_Cero DO
			SELECT LEFT(Par_ListaClasifClavPresup,Var_PosConjunto - Entero_Uno) INTO Var_Conjunto;
            
            WHILE Var_Conjunto != Cadena_Vacia DO
				SELECT POSITION( DelimitGion IN Var_Conjunto ) INTO Var_PosGuion;
                    SELECT CAST(LEFT(Var_Conjunto, Var_PosGuion - Entero_Uno)  AS CHAR) INTO Var_ClasifClavPresupID;
                    SELECT RIGHT(Var_Conjunto,LENGTH(Var_Conjunto) - Var_PosGuion) INTO Var_MontoTotal;
                    SET Var_Conjunto := Cadena_Vacia;
			END WHILE;

			IF(Var_ClasifClavPresupID = 'PC') THEN
				SET Var_MontoTotal = Var_MontoTotal/100;
			END IF;

            INSERT INTO FORMAPLICTMP
            SELECT Var_ClasifClavPresupID,Var_MontoTotal;
		
			SELECT SUBSTRING(Par_ListaClasifClavPresup, Var_PosConjunto + Entero_Uno, LENGTH(Par_ListaClasifClavPresup)) INTO Par_ListaClasifClavPresup;
			SELECT POSITION(DelimitComa IN Par_ListaClasifClavPresup) INTO Var_PosConjunto;
		END WHILE;

		-- Verificamos que se cumplan todas las claves presupuestales de la formula
		SELECT COUNT(*)
			INTO Var_CantFalt
			FROM TMP_FORMULA AS FRM
			LEFT JOIN FORMAPLICTMP AS VAL ON FRM.NomClasifClavPresup = VAL.NomClasifClavPresup
			WHERE VAL.NomClasifClavPresup IS NULL;
		SET Var_Contador := 0;

		WHILE Var_Contador < Var_CantFalt DO
			SET Var_ClasifClavPresupID := NULL;

			SELECT 		FRM.NomClasifClavPresup
				INTO 	Var_ClasifClavPresupID
				FROM TMP_FORMULA AS FRM
				LEFT JOIN FORMAPLICTMP AS VAL ON FRM.NomClasifClavPresup = VAL.NomClasifClavPresup
				WHERE VAL.NomClasifClavPresup IS NULL
				LIMIT 1;

			INSERT INTO FORMAPLICTMP
				SELECT Var_ClasifClavPresupID, Entero_Cero;

			SET Var_Contador := Var_Contador + 1;
		END WHILE;

        -- OPCION DE PONER TODOS LOS VALORES COMO CLAVES UNICAS
		IF Var_FormulaAplic REGEXP Pattern THEN 
			   loop_label: LOOP 
				   IF IncrementaLoop>CHAR_LENGTH(Var_FormulaAplic) THEN
					   LEAVE loop_label;  
				   END IF;

				   SET PosicionText = SUBSTRING(Var_FormulaAplic,IncrementaLoop,1);
				   
				   IF NOT PosicionText REGEXP Pattern THEN
					   SET FormulaAplicTMP = CONCAT(FormulaAplicTMP,PosicionText);
				   ELSE
					   SET FormulaAplicTMP = CONCAT(FormulaAplicTMP,'&',PosicionText,'&');
				   END IF;

				   SET IncrementaLoop=IncrementaLoop+1;
			   END LOOP;
		   ELSE
			   SET FormulaAplicTMP = Var_FormulaAplic;
		   END IF;
        SET FormulaAplicTMP = CONCAT('&',FormulaAplicTMP,'&');
        -- SE RECORRE LA TABLA PARA ASIGNAR VALOR A LA FORMULA
        SELECT COUNT(NomClasifClavPresup) 
        FROM FORMAPLICTMP 
			INTO Var_TotalReg;
		
        -- OPCION CON CLAVES UNICAS
		WHILE Incremental < Var_TotalReg DO
			SET FormulaAplicTMP := (SELECT REPLACE(FormulaAplicTMP,CONCAT('&',NomClasifClavPresup,'&'),MontoTotal) 
								FROM FORMAPLICTMP ORDER BY NomClasifClavPresup DESC LIMIT Incremental,1);
			SET Incremental = Incremental + 1;
		END WHILE;
        
        SET Var_FormulaAplic := (SELECT REPLACE(FormulaAplicTMP,'&',''));

        -- EJECUCION DE FORMULA
        FormulaErrores:BEGIN
			DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
                    SET Par_NumErr		:= 003;
					SET Par_ErrMen		:= concat('Error - Verifique la Fórmula ',Var_DesMensajeFormula);
                    SET Var_Control		:= 'Par_SolicitudCreditoID';
                    SET Var_Consecutivo	:= Entero_Cero;
				END;
			SELECT CONCAT('INSERT INTO RESULTADOTMP 
					SELECT ROUND(',Var_FormulaAplic,',2);')
			INTO Var_EjecutaFormula;
	
			SET @Sentencia    = (Var_EjecutaFormula);
			PREPARE EjecutaProc FROM @Sentencia;
			EXECUTE  EjecutaProc;
            
            SELECT CapacidadPago FROM RESULTADOTMP
			INTO Var_CapacidadPago;

			SET Par_NumErr		:= 0;
        END FormulaErrores;
        
        DROP TABLE IF EXISTS RESULTADOTMP;
        DROP TABLE IF EXISTS FORMAPLICTMP;
        
        if(Par_NumErr <> 003)then
			SET Par_NumErr 		:= 0;
			SET Par_ErrMen 		:= 'Proceso Realizado Exitosamente';
			SET Var_Control		:= 'Par_SolicitudCreditoID';
			SET Var_Consecutivo	:= Par_SolicitudCreditoID;
        end if;
		
	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS Control,
            Var_CapacidadPago AS Consecutivo;
	END IF;

END TerminaStore$$
