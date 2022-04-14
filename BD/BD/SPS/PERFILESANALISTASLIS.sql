DELIMITER ;
DROP PROCEDURE IF EXISTS `PERFILESANALISTASLIS`; 
DELIMITER $$

CREATE PROCEDURE `PERFILESANALISTASLIS`(

	Par_NumLis			TINYINT UNSIGNED,	-- Numero de consulta
	-- Parametros de Auditoria
	Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminAStore: BEGIN

	-- Declaracion de Variables
	DECLARE     Var_Analista    CHAR(1);		-- Tipo perfil Analista
	DECLARE     Var_Ejecutivo   CHAR(1);		-- Tipo perfil Ejecutivo
    DECLARE 	Var_Control		VARCHAR(100);	-- Control de Retorno en pantalla
    DECLARE 	Var_PerfilExpediente	VARCHAR(100);	-- Almacena el perfil expediente de la tabla PARAMGENERALES
    DECLARE 	Var_PerfilExpParametro	VARCHAR(100);	-- Almacena el parametro de la tabla PARAMGENERALES
    DECLARE   	Lis_Ejecutivos	INT;            -- Consulta solo de tipo perfil ejecutivo
    DECLARE	    Lis_AnalistAS	INT;            -- Consulta solo de tipo perfil analista
    DECLARE	    Entero_Cero	    INT;            -- Consulta solo de tipo perfil analista
    DECLARE     Cadena_Vacia    CHAR(1);
	-- Declaracion de Constantes


	-- ASignacion de Constantes
	SET Var_Analista		    :='A';             -- A  para tipo Analista
	SET Var_Ejecutivo		    :='E';             -- E para tipo Ejecutivos
    SET	Lis_AnalistAS			:=1;	            -- 1 lista para tipo Ejecutivos
	SET	Lis_Ejecutivos			:=2;	            -- 2 para lista de tipo Ejecutivos
	SET Entero_Cero             :=0;	            -- entero cero
	SET Cadena_Vacia    		:='';              -- cadena vacia
    SET Var_PerfilExpParametro='PerfilEdicionExpediente'; -- valor para parametro en la tabla de PARAMGENERALES



	SET Var_PerfilExpediente	:= (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Var_PerfilExpParametro);
    SET Var_PerfilExpediente	:= IFNULL(Var_PerfilExpediente,Cadena_Vacia);

	IF(IFNULL(Par_NumLis, Entero_Cero)) = Lis_AnalistAS THEN
		SELECT P.PerfilID,	LPAD(CONVERT(P.RolID, CHAR), 3, '0') AS RolID ,P.TipoPerfil,R.NombreRol,Var_PerfilExpediente AS PerfilExpediente 
		FROM PERFILESANALISTAS P
		INNER JOIN ROLES R  ON P.RolID=R.RolID
		WHERE P.TipoPerfil=Var_Analista;
	END IF;
	
    IF(IFNULL(Par_NumLis, Entero_Cero)) = Lis_Ejecutivos THEN
		SELECT P.PerfilID, LPAD(CONVERT(P.RolID, CHAR), 3, '0') AS RolID,P.TipoPerfil,R.NombreRol,Var_PerfilExpediente AS PerfilExpediente 
		FROM PERFILESANALISTAS P
		INNER JOIN ROLES R  ON P.RolID=R.RolID
		WHERE P.TipoPerfil=Var_Ejecutivo;
    END IF;





END TerminAStore$$