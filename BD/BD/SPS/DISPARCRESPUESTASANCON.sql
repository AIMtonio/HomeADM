-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ACTIVOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `DISPARCRESPUESTASANCON`;

DELIMITER $$
CREATE PROCEDURE `DISPARCRESPUESTASANCON`(
	# =====================================================================================
	# ------- STORED PARA CONSULTA ARCHIVOS PROCESADOS ---------
	# =====================================================================================
	Par_NombreArchivo       VARCHAR(100),        	-- Nombre del archiv
	Par_NumCon          	TINYINT UNSIGNED,   -- Numero de consulta

	Aud_EmpresaID           INT(11),        -- Parametro de auditoria ID de la empresa
	Aud_Usuario             INT(11),        -- Parametro de auditoria ID del usuario
	Aud_FechaActual         DATETIME,       -- Parametro de auditoria Fecha actual
	Aud_DireccionIP         VARCHAR(15),    -- Parametro de auditoria Direccion IP
	Aud_ProgramaID          VARCHAR(50),    -- Parametro de auditoria Programa
	Aud_Sucursal            INT(11),        -- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion      BIGINT(20)      -- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES


	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia        CHAR(1);            -- Constante cadena vacia ''
	DECLARE Fecha_Vacia         DATE;               -- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero         INT(1);             -- Constante Entero cero 0
	DECLARE Decimal_Cero        DECIMAL(14,2);      -- DECIMAL cero
	DECLARE Con_CtasActivas		INT(11);
	DECLARE Con_CtasPendientes	INT(11);
	DECLARE Con_TransferSantan	INT(11);
	DECLARE Con_OrdenPago		INT(11);
    DECLARE Var_NombreArchivo	VARCHAR(200);

	-- ASIGNACION DE CONSTANTES

	SET Cadena_Vacia            := '';
	SET Fecha_Vacia             := '1900-01-01';
	SET Entero_Cero             := 0;
	SET Decimal_Cero            := 0.0;
	SET Con_CtasActivas			:= 1;
	SET Con_CtasPendientes		:= 2;
	SET Con_TransferSantan		:= 3;
	SET Con_OrdenPago			:= 4;



	-- Consulta 1.- CUENTAS ACTIVAS
	IF(Par_NumCon = Con_CtasActivas) THEN
		SET Var_NombreArchivo := (
		SELECT NombreArchivo AS Archivo 
			FROM DISPCTAACTIVAS 
			WHERE NombreArchivo=Par_NombreArchivo
			LIMIT 1);  
		SET Var_NombreArchivo := IFNULL(Var_NombreArchivo, Cadena_Vacia);
	END IF;
    
    -- Consulta 2.- CUENTAS PENDIENTES
	IF(Par_NumCon = Con_CtasPendientes) THEN
		SET Var_NombreArchivo := (
		SELECT NombreArchivo AS Archivo 
			FROM DISPCTAPENDIENTES 
			WHERE NombreArchivo=Par_NombreArchivo
			LIMIT 1);  
		SET Var_NombreArchivo := IFNULL(Var_NombreArchivo, Cadena_Vacia);
	END IF;
    
    -- Consulta 3.- TRANSFERENCIA SANTANDER
	IF(Par_NumCon = Con_TransferSantan) THEN			
		SET Var_NombreArchivo := (
		SELECT NombreArchivo AS Archivo 
			FROM DISPTRANSFERENCIASAN 
			WHERE NombreArchivo=Par_NombreArchivo
			LIMIT 1);  
		SET Var_NombreArchivo := IFNULL(Var_NombreArchivo, Cadena_Vacia);        
	END IF;
    
     -- Consulta 4.- ORDEN DE PAGO
	IF(Par_NumCon = Con_OrdenPago) THEN
        SET Var_NombreArchivo := (
		SELECT NombreArchivo AS Archivo 
			FROM DISPORDENPAGOSAN 
			WHERE NombreArchivo=Par_NombreArchivo
			LIMIT 1);  
		SET Var_NombreArchivo := IFNULL(Var_NombreArchivo, Cadena_Vacia);
	END IF;
    
	SELECT Var_NombreArchivo AS Archivo;

END TerminaStore$$