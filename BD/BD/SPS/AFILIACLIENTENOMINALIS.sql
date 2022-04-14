DELIMITER ;
DROP PROCEDURE IF EXISTS `AFILIACLIENTENOMINALIS`;
DELIMITER $$
CREATE PROCEDURE `AFILIACLIENTENOMINALIS`(
	Par_ClienteID				INT(11),			-- Identificador del  Cliente
	Par_NombreComp				VARCHAR(50),		-- Nombre del Cliente
	Par_NumLis					INT(11),			-- Numero de Lista
	Par_InstNomina				INT(11),			-- Institucion nomina al que pertenece
	Par_TipoOpera				CHAR(1),			-- Tipo Operacion Alta o Baja
    Par_Convenio				VARCHAR(50),		-- Numero de convenio con la empresa de nomina
	Par_EsNomina				CHAR(1),			-- imdica si pretenece a una nomina o no

	Par_EmpresaID				INT(11),			-- Parametro de Auditoria
	Aud_Usuario					INT(11),			-- Parametro de Auditoria
	Aud_FechaActual				DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal				INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore: BEGIN

    -- Declaracion de Variables
	DECLARE Var_Afiliacion		CHAR(1);
	DECLARE Var_Sentencia		VARCHAR(3000);
    DECLARE Var_MontoMaxAfilia	DECIMAL(20,2);

	-- Declaracion de Constantes
	DECLARE Entero_Cero			INT(11);
    DECLARE Cadena_Vacia		CHAR(1);
    DECLARE Con_Afiliado		CHAR(1);
    DECLARE Con_NoAfiliado		CHAR(1);
    DECLARE Con_EstVigente		CHAR(1);
    DECLARE Con_Alta			CHAR(1);
    DECLARE Con_Baja			CHAR(1);
	DECLARE Con_Credito			CHAR(1);
    DECLARE Con_Ambas			CHAR(1);
    DECLARE Con_SI				CHAR(1);
	DECLARE Con_NO				CHAR(1);

	DECLARE Lis_AfiliacionCliente	INT(11);			-- Lista clientes de una empresa de nomina
	DECLARE Lis_General				INT(11);			-- Lista Clientes con o sin nomina para el grid
	DECLARE Lis_Convenios			INT(11);

	-- Asignacion de Constantes
    SET Entero_Cero				:= 0;				-- Entero Cero
    SET Cadena_Vacia			:='';				-- Cadena Vacia
    SET Con_Afiliado			:= 'A';				-- Afiliado
    SET Con_NoAfiliado			:= 'N';				-- No Afiliado
    SET Con_EstVigente			:= 'V';				-- Vigente
    SET Con_Alta				:= 'A';				-- Alta de la cuenta clabe
    SET Con_Baja				:= 'B';				-- Baja de la cuenta Clabe
    SET Con_Credito				:= 'C';				-- Constante para SPEI
    SET Con_Ambas				:= 'A';				-- Constante para Ambas
	SET Con_SI					:= 'S';				-- Constante: SI
	SET Con_NO					:= 'N';				-- Constante: NO

    SET Lis_AfiliacionCliente	:= 1;				-- Lista clientes para afiliacion de cuenta clabe con estatus No afiliados
	SET Lis_General				:= 2;				-- Lista general para el grid ya sean de nomina o no
	SET Lis_Convenios			:= 3;				-- Lista de Convenios de Institucion de Nomina
     SET Var_MontoMaxAfilia := 0.0;

	IF(Par_TipoOpera = Con_Alta)THEN
		SET Var_Afiliacion := Con_NoAfiliado;
	END IF;

	IF(Par_TipoOpera = Con_Baja)THEN
		SET Var_Afiliacion := Con_Afiliado;
	END IF;


    /* 1.- Lista para realizar la busqueda de los clientes para afiliacion */
    IF Par_NumLis = Lis_AfiliacionCliente THEN
		SET Var_Sentencia := 'SELECT DISTINCT C.ClienteID,C.NombreCompleto FROM CLIENTES C';
		SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN CUENTASTRANSFER CT ON CT.ClienteID = C.ClienteID AND CT.EstatusDomici	=\'',Var_Afiliacion,'\' AND	CT.AplicaPara	IN	(\'',Con_Credito,'\',\'',Con_Ambas,'\')');

		IF (IFNULL(Par_InstNomina,Entero_Cero) != Entero_Cero) THEN
			SET Var_Sentencia := CONCAT( Var_Sentencia,' INNER JOIN NOMINAEMPLEADOS  N ON N.ClienteID = C.ClienteID AND N.InstitNominaID =', Par_InstNomina,' INNER JOIN INSTITNOMINA I ON I.InstitNominaID = N.InstitNominaID');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' INNER JOIN CONVENIOSNOMINA CN ON N.InstitNominaID	=	CN.InstitNominaID	AND	CN.ConvenioNominaID=',Par_Convenio,' AND CN.DomiciliacionPagos =\'',Con_SI,'\' WHERE  ');
		    SET Var_Sentencia := CONCAT(Var_Sentencia,'C.NombreCompleto LIKE CONCAT(','"%",\'',Par_NombreComp,'\',"%") AND CT.Estatus= "A" AND CT.TipoCuentaSpei=40 LIMIT 0,15;');
        END IF;
		IF (IFNULL(Par_InstNomina,Entero_Cero) = Entero_Cero) THEN
     
			SET Var_Sentencia := CONCAT(Var_Sentencia,' LEFT JOIN NOMINAEMPLEADOS N ON C.ClienteID = N.ClienteID WHERE N.ClienteID IS NOT NULL AND N.Estatus = "B" OR N.ClienteID IS NULL AND ');
			SET Var_Sentencia := CONCAT(Var_Sentencia,'C.NombreCompleto LIKE CONCAT(','"%",\'',Par_NombreComp,'\',"%") AND CT.Estatus= "A" AND CT.TipoCuentaSpei=40 LIMIT 0,15;');
        END IF;
		
		
		SET @Sentencia  = (Var_Sentencia);

		PREPARE Ejecuta FROM @Sentencia;
		EXECUTE Ejecuta;
		DEALLOCATE PREPARE Ejecuta;

    END IF;

	  /* 2.- Lista general para el grid ya sean de nomina o no */
    IF Par_NumLis = Lis_General THEN
		SELECT ValorParametro INTO Var_MontoMaxAfilia
        FROM PARAMGENERALES
        WHERE LlaveParametro='MontoMaxAfiliacion';
       

		SET Var_Sentencia:=CONCAT( 'SELECT 	CT.Clabe,						cte.ClienteID,		cte.RFCOficial,	CONCAT(cte.ClienteID,cte.RFCOficial) Referencia	,SUBSTRING(cte.NombreCompleto,1,40) AS NombreCompleto,		cte.TipoPersona,
										I.InstitucionID, 				UPPER(I.NombreCorto) AS NombreCorto,			IFNULL(N.InstitNominaID,0) InstitNominaID,	IFNULL(N.NombreInstit,\'.\') NombreInstit, 		CT.EstatusDomici,',
							Var_MontoMaxAfilia, ' AS MontoMaxCobro, '		,'LPAD(CT.TipoCuentaSpei,2,0) AS TipoCuentaSpei,	IFNULL(ID.NumIdentific,"") AS NumIdentific, 	IFNULL(ID.TipoIdentiID,0) AS TipoIdentiID, 	IFNULL(CN.ConvenioNominaID,0) Convenio,I.Folio');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' FROM CLIENTES cte');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN IDENTIFICLIENTE ID	ON	cte.ClienteID	=	ID.ClienteID	AND	ID.Oficial=	"S"');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' LEFT JOIN NOMINAEMPLEADOS S	ON	cte.ClienteID	=	S.ClienteID ');

        IF (IFNULL(Par_InstNomina,Entero_Cero) = Entero_Cero) AND Par_EsNomina = Con_SI THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,' AND	S.InstitNominaID !=',Par_InstNomina);
		END IF;

		IF (Par_InstNomina != Entero_Cero) AND Par_EsNomina = Con_SI THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,' AND	S.InstitNominaID =',Par_InstNomina);
		END IF;


		SET Var_Sentencia := CONCAT(Var_Sentencia,' LEFT JOIN INSTITNOMINA N		ON	S.InstitNominaID =	N.InstitNominaID');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' LEFT JOIN CONVENIOSNOMINA CN	ON	N.InstitNominaID	=	CN.InstitNominaID	AND CN.DomiciliacionPagos =\'', Con_SI,'\' AND	CN.ConvenioNominaID =IFNULL(\'',Par_Convenio,'\',0)');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN CUENTASTRANSFER CT	ON	cte.ClienteID	=	CT.ClienteID AND	CT.EstatusDomici	=\'',Var_Afiliacion,'\' AND	CT.AplicaPara	IN	(\'',Con_Credito,'\',\'',Con_Ambas,'\')');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' LEFT JOIN INSTITUCIONES I		ON	CT.InstitucionID	=	I.ClaveParticipaSpei');

		IF (Par_EsNomina = Con_SI) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,' WHERE S.ClienteID IS NOT NULL AND CT.Estatus= "A" AND CT.TipoCuentaSpei=40 ');
		END IF;
		IF  (Par_EsNomina = Con_NO) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,' WHERE (S.ClienteID IS NOT NULL  AND CT.TipoCuentaSpei=40 AND S.Estatus = "B"  OR S.ClienteID IS NULL ) AND CT.Estatus= "A" ');
		END IF;

		IF (Par_ClienteID = Entero_Cero) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,' ORDER BY cte.ClienteID;');
        END IF;

		IF (Par_ClienteID != Entero_Cero) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,' AND  cte.ClienteID	=',Par_ClienteID);
		END IF;

		SET Var_Sentencia := CONCAT(Var_Sentencia,';');
		SET @Sentencia  = (Var_Sentencia);

		PREPARE Ejecuta FROM @Sentencia;
		EXECUTE Ejecuta;
		DEALLOCATE PREPARE Ejecuta;
        
    END IF;

    /* 3.- Lista de Convenios de Institucion de Nomina */
    IF Par_NumLis = Lis_Convenios THEN
		SELECT ConvenioNominaID
        FROM CONVENIOSNOMINA
        WHERE InstitNominaID = Par_InstNomina
        AND DomiciliacionPagos = Con_SI;
	END IF;

END TerminaStore$$