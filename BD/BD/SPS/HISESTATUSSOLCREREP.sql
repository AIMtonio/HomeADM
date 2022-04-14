-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISESTATUSSOLCREREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `HISESTATUSSOLCREREP`;
DELIMITER $$

CREATE PROCEDURE `HISESTATUSSOLCREREP`(
	-- SP historico de estatus de una solicitud de credito
	Par_SolicCredID         BIGINT(20),			-- Numero de Solicitud
    
	Aud_EmpresaID			INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATE,				-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
        )
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_Sentencia	VARCHAR(6000);	-- Sentencia del reporte
    
	-- Declaracion de constantes
	DECLARE Entero_Cero 		INT(11);	-- Entero cero
    DECLARE Cadena_Vacia		CHAR(1);	-- Cadena vacia 
	DECLARE Cadena_NoAplica		CHAR(2);	-- Cadena NA
    
	DECLARE Estatus_Inactivo	CHAR(1);	-- Estatus  : I
    DECLARE Estatus_Liberada	CHAR(1);	-- Estatus  : L
    DECLARE Estatus_EnAnalisis	CHAR(1);	-- Estatus  : E
    DECLARE Estatus_Devuelta	CHAR(1);	-- Estatus  : B
    DECLARE Estatus_Cancelada	CHAR(1);	-- Estatus  : C
    DECLARE Estatus_Rechazada	CHAR(1);	-- Estatus  : R
    DECLARE Estatus_Autorizada	CHAR(1);	-- Estatus  : A
    DECLARE Estatus_Condiciona	CHAR(1);	-- Estatus  : S
    DECLARE Estatus_Descondicio	CHAR(1);	-- Estatus  : F
    DECLARE Estatus_Desembolsa	CHAR(1);	-- Estatus  : D
    DECLARE Estatus_Dispersada	CHAR(1);	-- Estatus  : P
    DECLARE Estatus_Asignada	CHAR(1);	-- Estatus	: G
    DECLARE Estatus_EnRevision	CHAR(1);	-- Estatus  : H

	DECLARE Texto_Inactivo		VARCHAR(10);	-- Estatus  : INACTIVO
    DECLARE Texto_Liberada		VARCHAR(10);	-- Estatus  : LIBERADA
    DECLARE Texto_EnAnalisis	VARCHAR(15);	-- Estatus  : EnANALISIS
    DECLARE Texto_Devuelta		VARCHAR(10);	-- Estatus  : DEVUELTA
    DECLARE Texto_Cancelada		VARCHAR(10);	-- Estatus  : CANCELADA
    DECLARE Texto_Rechazada		VARCHAR(10);	-- Estatus  : RECHAZADA
    DECLARE Texto_Autorizada	VARCHAR(10);	-- Estatus  : AUTORIZADA
    DECLARE Texto_Autorizado	VARCHAR(10);	-- Estatus  : AUTORIZADA
    DECLARE Texto_Condiciona	VARCHAR(12);	-- Estatus  : CONDICIONADO
    DECLARE Texto_Descondicio	VARCHAR(15);	-- Estatus  : DESCONDICIONADO
    DECLARE Texto_Desembolsa	VARCHAR(12);	-- Estatus  : DESEMBOLSADO
    DECLARE Texto_Dispersada	VARCHAR(10);	-- Estatus  : DISPERSADO
    DECLARE Texto_Asignada		VARCHAR(10);	-- Estatus	: ASIGNADA
    DECLARE Texto_EnRevision	VARCHAR(15);	-- Estatus  : EnREVISION
    DECLARE Texto_CreaCredito	VARCHAR(25);	-- Estatus  : EnREVISION
    
	-- Asignacion de variables y constantes
	SET Entero_Cero		 	:= 0;
    SET Cadena_Vacia		:= '';
    SET Cadena_NoAplica		:= 'NA';
    
    SET Estatus_Inactivo	:= 'I';
    SET Estatus_Liberada	:= 'L';
    SET Estatus_EnAnalisis	:= 'E';
    SET Estatus_Devuelta	:= 'B';
    SET Estatus_Cancelada	:= 'C';
    SET Estatus_Rechazada	:= 'R';
    SET Estatus_Autorizada	:= 'A';
    SET Estatus_Condiciona	:= 'S';
    SET Estatus_Descondicio	:= 'F';
    SET Estatus_Desembolsa	:= 'D';
    SET Estatus_Dispersada	:= 'P';
    SET Estatus_Asignada	:= 'G';
    SET Estatus_EnRevision	:= 'H';
    
    SET Texto_Inactivo		:= 'INACTIVO';
    SET Texto_Liberada		:= 'LIBERADA';
    SET Texto_EnAnalisis	:= 'EN ANALISIS';
    SET Texto_Devuelta		:= 'DEVUELTA';
    SET Texto_Cancelada		:= 'CANCELADA';
    SET Texto_Rechazada		:= 'RECHAZADA';
    SET Texto_Autorizada	:= 'AUTORIZADA';
    SET Texto_Autorizado	:= 'AUTORIZADO';
    SET Texto_Condiciona	:= 'CONDICIONADO';
    SET Texto_Descondicio	:= 'DESCONDICIONADO';
    SET Texto_Desembolsa	:= 'DESEMBOLSADO';
    SET Texto_Dispersada	:= 'DISPERSADO';
    SET Texto_Asignada		:= 'ASIGNADA';
    SET Texto_EnRevision	:= 'EN REVISION';
    SET Texto_CreaCredito	:= 'CREACION CREDITO';
    
	SET Par_SolicCredID	:= IFNULL(Par_SolicCredID,Entero_Cero);

	-- Crear tabla temporal para obtener las descripciones de los motivos de rechazo
    DROP TEMPORARY TABLE IF EXISTS TMPDESCMOTRECHAZOS;
	CREATE TEMPORARY TABLE TMPDESCMOTRECHAZOS(
		EstatusSolCredID	BIGINT(20) NOT NULL ,
		Descripciones		VARCHAR(500),
        PRIMARY KEY (`EstatusSolCredID`)
	);

    INSERT INTO TMPDESCMOTRECHAZOS 
    SELECT est.EstatusSolCreID AS EstatusSolCredID , GROUP_CONCAT(ctr.Descripcion) AS Descripciones
    FROM ESTATUSSOLCREDITOS est INNER JOIN CATALOGOMOTRECHAZO ctr 
    WHERE FIND_IN_SET(ctr.MotivoRechazoID,est.MotivoRechazoID)>0 AND est.SolicitudCreditoID=Par_SolicCredID
    GROUP BY est.EstatusSolCreID;


    SET Var_Sentencia	:=	Cadena_Vacia;
    
    SELECT est.EstatusSolCreID,     est.HoraActualizacion,       est.Fecha,est.UsuarioAct as UsuarioID,    est.Estatus,    est.MotivoRechazoID,
        CASE WHEN com.Comentario = Cadena_Vacia OR est.Estatus = Estatus_Asignada OR est.Estatus = Estatus_Dispersada THEN Cadena_NoAplica
            ELSE com.Comentario END AS Comentario,
        CASE       WHEN est.Estatus  = Estatus_Inactivo    AND   est.CreditoID = 0   THEN  Texto_Inactivo
					WHEN est.Estatus = Estatus_Liberada    AND   est.CreditoID = 0   THEN  Texto_Liberada  
					WHEN est.Estatus = Estatus_EnAnalisis  AND   est.CreditoID = 0   THEN  Texto_EnAnalisis  
					WHEN est.Estatus = Estatus_Devuelta    AND   est.CreditoID = 0   THEN  Texto_Devuelta 
					WHEN est.Estatus = Estatus_Cancelada   AND   est.CreditoID = 0   THEN  Texto_Cancelada 
					WHEN est.Estatus = Estatus_Rechazada   AND   est.CreditoID = 0   THEN  Texto_Rechazada 
					WHEN est.Estatus = Estatus_Autorizada  AND   est.CreditoID = 0   THEN  Texto_Autorizada 
					WHEN est.Estatus = Estatus_Inactivo    AND   est.CreditoID <> 0  THEN  Texto_CreaCredito 
					WHEN est.Estatus = Estatus_Condiciona  AND   est.CreditoID <> 0  THEN  Texto_Condiciona 
					WHEN est.Estatus = Estatus_Autorizada  AND   est.CreditoID <> 0  THEN  Texto_Autorizado 
					WHEN est.Estatus = Estatus_Descondicio AND   est.CreditoID <> 0  THEN  Texto_Descondicio 
					WHEN est.Estatus = Estatus_Desembolsa  AND   est.CreditoID <> 0  THEN  Texto_Desembolsa 
					WHEN est.Estatus = Estatus_Dispersada  AND   est.CreditoID <> 0  THEN  Texto_Dispersada 
					WHEN est.Estatus = Estatus_Asignada    THEN  Texto_Asignada 
					WHEN est.Estatus = Estatus_EnRevision  THEN  Texto_EnRevision 
		END AS NombreEstatus,
		IFNULL(tmp.Descripciones, Cadena_NoAplica) AS MotivoRechazo,usu.NombreCompleto as Usuario 
    FROM  ESTATUSSOLCREDITOS est INNER JOIN USUARIOS usu ON est.UsuarioAct=usu.UsuarioID
    LEFT JOIN TMPDESCMOTRECHAZOS tmp ON est.EstatusSolCreID=tmp.EstatusSolCredID LEFT JOIN COMENTARIOSSOL com  ON com.NumTransaccion=est.NumTransaccion
    WHERE est.SolicitudCreditoID= CONVERT(Par_SolicCredID,CHAR)  ORDER BY est.Fecha, est.HoraActualizacion,  est.EstatusSolCreID ASC;
	
	DROP TABLE IF EXISTS TMPDESCMOTRECHAZOS;
END TerminaStore$$
