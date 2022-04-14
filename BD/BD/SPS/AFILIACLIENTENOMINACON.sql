DELIMITER ;
DROP PROCEDURE IF EXISTS `AFILIACLIENTENOMINACON`;
DELIMITER $$
CREATE PROCEDURE `AFILIACLIENTENOMINACON`(
	/*SP que consulta al cliente que pertenece a nomina o
    los que tienen un credito con pago domiciliado*/
    Par_ClienteID		INT(11),			-- Identificador del cliente
    Par_NumInstNomina	INT(11),			-- Numero de institucion de nomina la que pertenece
    Par_TipoOpera		CHAR(1),			-- Tipo de operacion a realizar
    Par_NumConsulta		INT(11),			-- Numero de consulta a realizar

    Par_EmpresaID			INT(11),		-- Parametro de auditoria
	Aud_Usuario         	INT(11),		-- Parametro de auditoria
	Aud_FechaActual     	DATETIME,		-- Parametro de auditoria
	Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria
	Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria
	Aud_Sucursal        	INT(11),		-- Parametro de auditoria
	Aud_NumTransaccion  	BIGINT(20)		-- Parametro de auditoria
)
TerminaStore:BEGIN
	-- Declaracion de variables
    DECLARE Var_Afiliacion	CHAR(1);
	-- Declaracion de constantes
	DECLARE Entero_Cero 	INT(11);			-- valor entero cero
    DECLARE Cadena_Vacia 	CHAR(1);			-- cadena vacia
    DECLARE Con_Principal	INT(11);			-- valor de la consulta principal
    DECLARE Con_EstVigente 	CHAR(1);			-- Estatus vigente
    DECLARE Con_Creditos	CHAR(1);			-- se utiliza para cuentas
    DECLARE Con_Ambas		CHAR(1);			-- Se utiliza para ambas
    DECLARE Con_Baja		CHAR(1);
    DECLARE Con_Alta		CHAR(1);
    DECLARE Con_Afiliado	CHAR(1);
    DECLARE Con_NoAfiliado	CHAR(1);


    DECLARE Var_Sentencia	VARCHAR(600);


    -- Seteo de constantes
    SET Entero_Cero		:= 0;
    SET Cadena_Vacia	:='';
    SET Con_Principal	:= 1;
    SET Con_EstVigente  := 'V';
    SET Con_Creditos	:=  'C';
    SET Con_Ambas		:= 'A';
    SET Con_Alta		:= 'A';
    SET Con_Baja		:= 'B';
    SET Con_Afiliado	:= 'A';
    SET Con_NoAfiliado	:= 'N';

	IF(Par_TipoOpera = Con_Alta)THEN
		SET Var_Afiliacion := Con_NoAfiliado;
	END IF;

	IF(Par_TipoOpera = Con_Baja)THEN
		SET Var_Afiliacion := Con_Afiliado;
	END IF;

    IF(Par_NumConsulta = Con_Principal)THEN
		SET Var_Sentencia := 'SELECT C.ClienteID,C.NombreCompleto FROM CLIENTES C';
		SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN CUENTASTRANSFER CT ON CT.ClienteID = C.ClienteID AND CT.EstatusDomici	=\'',Var_Afiliacion,'\' AND	CT.AplicaPara	IN	(\'',Con_Creditos,'\',\'',Con_Ambas,'\')');

		IF IFNULL(Par_NumInstNomina,Entero_Cero) != Entero_Cero THEN
			SET Var_Sentencia :=CONCAT( Var_Sentencia,' INNER JOIN NOMINAEMPLEADOS  N ON N.ClienteID = C.ClienteID AND InstitNominaID =', Par_NumInstNomina,' INNER JOIN INSTITNOMINA I ON I.InstitNominaID = N.InstitNominaID');
		END IF;

		SET Var_Sentencia := CONCAT(Var_Sentencia,' WHERE C.ClienteID=',Par_ClienteID,' LIMIT 1;');

        SET @Sentencia  = (Var_Sentencia);

		PREPARE Ejecuta FROM @Sentencia;
		EXECUTE Ejecuta;
		DEALLOCATE PREPARE Ejecuta;
    END IF;

END TerminaStore$$