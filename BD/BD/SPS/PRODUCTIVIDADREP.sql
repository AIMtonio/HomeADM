-- PRODUCTIVIDADREP

DELIMITER ;
DROP PROCEDURE IF EXISTS `PRODUCTIVIDADREP`;

DELIMITER $$
CREATE PROCEDURE `PRODUCTIVIDADREP`(
	Par_UsuarioID           INT(11), 			-- ID del analista, cero indica todos
	Par_FechaInicial		DATE,				-- Fecha incial del periodo
    Par_FechaFinal			DATE,				-- Fecha final del perido

	Par_EmpresaID           INT,				-- Parametro de Auditoria
	Aud_Usuario             INT,				-- Parametro de Auditoria
	Aud_FechaActual         DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP         VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID          VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal            INT,				-- Parametro de Auditoria		
	Aud_NumTransaccion      BIGINT(20) UNSIGNED	-- Parametro de Auditoria
	)

TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_NumSolicitudes	INT;			-- Total de solicitudes de credito en la consulta del periodo
DECLARE Var_Sentencia		VARCHAR(5000);	-- para SQL query
DECLARE Var_FechaSistema	DATE;			-- Fecha del sistema
DECLARE Var_TotAsignadas	INT;
DECLARE Var_TotRevision		INT;
DECLARE Var_TotDevueltas	INT;
DECLARE Var_TotCanceladas	INT;
DECLARE Var_TotRechazadas	INT;
DECLARE Var_TotAutorizadas	INT;
DECLARE Var_TotPendientesGlo	INT;
DECLARE Var_TotAutorizadasGlo	INT;

-- Declaracion de constantes
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Tipo_Detalle		CHAR(1);
DECLARE Tipo_Total			CHAR(1);
DECLARE Entero_Cero			INT;
DECLARE Entero_Uno			INT;
DECLARE Fecha_Vacia			DATE;		
DECLARE Estatus_Cancelada	CHAR(1);		-- Estatus de solicitud de credito cancelada
DECLARE Estatus_Autorizada	CHAR(1);		-- Estatus de solicitud de credito autorizada
DECLARE Estatus_Devuelta	CHAR(1);		-- Estatus de solicitud de credito devuelta
DECLARE Estatus_Rechazada	CHAR(1);		-- Estatus de solicitud de credito rechazada
DECLARE Estatus_EnRevision	CHAR(1);		-- Estatus de solicitud de credito en revision
DECLARE Estatus_Asignada	CHAR(1);		-- Estatus de solicitud de credito en asignadas
DECLARE Cadena_Virtual		VARCHAR(7);		-- Analista 0, osea analista virtual
DECLARE Var_FechaIni		DATETIME;
DECLARE Var_FechaFin		DATETIME;
-- Asignacion de constantes y variables

SET	Cadena_Vacia		:= '';
SET	Fecha_Vacia			:= '1900-01-01';
SET	Entero_Cero			:= 0;
SET	Entero_Uno			:= 1;
SET Estatus_Cancelada	:= 'C';
SET Estatus_Autorizada	:= 'A';
SET Estatus_Devuelta	:= 'B';
SET Estatus_Rechazada	:= 'R';
SET Estatus_EnRevision	:= 'E';
SET Estatus_Asignada	:= 'A';
SET Cadena_Virtual		:= 'VIRTUAL';
SET Tipo_Detalle		:= 'R';
SET Tipo_Total			:= 'T';

SET Var_FechaSistema	:= (SELECT FechaSistema FROM PARAMETROSSIS);
SET Var_Sentencia		:= Cadena_Vacia;

-- Asignacion parametros
SET Par_FechaInicial	:= IFNULL(Par_FechaInicial,Fecha_Vacia);
SET Par_FechaFinal		:= IFNULL(Par_FechaFinal, Fecha_Vacia);
SET Par_UsuarioID		:= IFNULL(Par_UsuarioID,Entero_Cero);

SET Var_FechaIni		:= CONCAT(Par_FechaInicial,' 00:00:00');
SET Var_FechaFin		:= CONCAT(Par_FechaFinal,' 23:59:59');


SET Aud_NumTransaccion	:= ROUND(RAND()*100000000);
DELETE FROM TMPANALISTASOLPROD WHERE Transaccion = Aud_NumTransaccion;
DELETE FROM TMPPRODUCTIVIDADREP WHERE Transaccion = Aud_NumTransaccion;
DELETE FROM TMPPRODUCTIVIDASUM WHERE Transaccion = Aud_NumTransaccion;

/* ---------------------------------------------------- 
	Se llenan las tablas con las solicitudes y usuarios
   que coinciden con el periodo de busqueda 
   ---------------------------------------------------- */ 
SET @Consecutivo := 0;
SET Var_Sentencia	:= 'INSERT INTO TMPANALISTASOLPROD';
SET Var_Sentencia	:= CONCAT(Var_Sentencia,' SELECT ',Aud_NumTransaccion,',(@Consecutivo:=@Consecutivo+1), UsuarioID,SolicitudCreditoID,Estatus,FechaAsignacion,1,1,NOW(),"127.0.0.1","WB",1,1');
SET Var_Sentencia	:= CONCAT(Var_Sentencia,' FROM SOLICITUDESASIGNADAS');
SET Var_Sentencia	:= CONCAT(Var_Sentencia,' WHERE FechaAsignacion BETWEEN "',Var_FechaIni,'" AND "',Var_FechaFin,'"');

IF Par_UsuarioID <> Entero_Cero THEN
	SET Var_Sentencia	:= CONCAT(Var_Sentencia,' AND UsuarioID = ',Par_UsuarioID);
END IF;

SET Var_Sentencia	:= CONCAT(Var_Sentencia,';');

SET @Sentencia	:= (Var_Sentencia);
PREPARE STRSOLICITUDES FROM @Sentencia;
EXECUTE STRSOLICITUDES;
DEALLOCATE PREPARE STRSOLICITUDES;

SET Var_Sentencia	:= 'INSERT INTO TMPANALISTASOLPROD';
SET Var_Sentencia	:= CONCAT(Var_Sentencia,' SELECT ',Aud_NumTransaccion,',(@Consecutivo:=@Consecutivo+1), UsuarioID,SolicitudCreditoID,Estatus,FechaAsignacion,1,1,NOW(),"127.0.0.1","WB",1,1');
SET Var_Sentencia	:= CONCAT(Var_Sentencia,' FROM HISSOLICITUDESASIGNADAS');
SET Var_Sentencia	:= CONCAT(Var_Sentencia,' WHERE FechaAsignacion BETWEEN "',Var_FechaIni,'" AND "',Var_FechaFin,'"');

IF Par_UsuarioID <> Entero_Cero THEN
	SET Var_Sentencia	:= CONCAT(Var_Sentencia,' AND UsuarioID = ',Par_UsuarioID);
END IF;

SET Var_Sentencia	:= CONCAT(Var_Sentencia,';');

SET @Sentencia	:= (Var_Sentencia);
PREPARE STRSOLICITUDES FROM @Sentencia;
EXECUTE STRSOLICITUDES;
DEALLOCATE PREPARE STRSOLICITUDES;

/* ---------------------------------------------------- 
	Llenamos la tabla principal agrupando las solicitudes
    asignadas y en revision
   ---------------------------------------------------- */ 
INSERT INTO TMPPRODUCTIVIDADREP
SELECT Aud_NumTransaccion,Sol.UsuarioID,
SUM(CASE WHEN Par_FechaFinal =  Var_FechaSistema  AND Sol.Estatus = Estatus_Asignada THEN Entero_Uno 
		 WHEN Par_FechaFinal <  Var_FechaSistema  THEN Entero_Uno 
         ELSE Entero_Cero END) AS Asignadas,
SUM(CASE WHEN Par_FechaFinal =  Var_FechaSistema  AND Sol.Estatus = Estatus_EnRevision THEN Entero_Uno 
         ELSE Entero_Cero END) as Revision, 
Entero_Cero AS Devueltas,		Entero_Cero AS Canceladas,		Entero_Cero AS Rechazadas,	
Entero_Cero AS Autorizadas,		Entero_Cero AS PendienteGlo,	Entero_Cero AS AutorizadasGlo,
Entero_Cero as PendientesInd,	Entero_Cero AS AutorizadasInd,	Tipo_Detalle,	Par_EmpresaID,
Aud_Usuario,					Aud_FechaActual,				Aud_DireccionIP,
Aud_ProgramaID,					Aud_Sucursal,					Aud_NumTransaccion
FROM TMPANALISTASOLPROD Sol
WHERE Sol.Transaccion = Aud_NumTransaccion
GROUP BY Sol.UsuarioID;

/* ---------------------------------------------------- 
	Llenamos la tabla de conteo de solicitudes
   ---------------------------------------------------- */ 
INSERT INTO TMPPRODUCTIVIDASUM
SELECT  Aud_NumTransaccion,Sol.UsuarioID,
SUM(CASE WHEN Btc.Estatus = Estatus_Devuelta AND CreditoID = Entero_Cero THEN Entero_Uno ELSE Entero_Cero END) AS Devueltas,
SUM(CASE WHEN Btc.Estatus = Estatus_Cancelada AND CreditoID = Entero_Cero THEN Entero_Uno ELSE Entero_Cero END) AS Canceladas,
SUM(CASE WHEN Btc.Estatus = Estatus_Rechazada AND CreditoID = Entero_Cero THEN Entero_Uno ELSE Entero_Cero END) AS Rechazadas,
SUM(CASE WHEN Btc.Estatus = Estatus_Autorizada AND CreditoID = Entero_Cero THEN Entero_Uno ELSE Entero_Cero END) AS Autorizada,
Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
 FROM
TMPPRODUCTIVIDADREP Sol,ESTATUSSOLCREDITOS Btc
WHERE Sol.UsuarioID = Btc.UsuarioAct
AND Btc.Fecha BETWEEN Par_FechaInicial AND Par_FechaFinal
AND Btc.Estatus IN (Estatus_Devuelta,Estatus_Cancelada,Estatus_Rechazada,Estatus_Autorizada)
AND Sol.Transaccion = Aud_NumTransaccion
GROUP BY Sol.UsuarioID;

UPDATE TMPPRODUCTIVIDADREP Sol, TMPPRODUCTIVIDASUM Tot 
	SET Sol.Devueltas = Tot.Devueltas,
		Sol.Canceladas = Tot.Canceladas,
        Sol.Rechazadas = Tot.Rechazadas,
        Sol.Autorizadas = Tot.Autorizadas
WHERE Sol.UsuarioID = Tot.UsuarioID
AND Sol.Transaccion = Tot.Transaccion 
AND Sol.Transaccion = Aud_NumTransaccion
AND Tot.Transaccion = Aud_NumTransaccion;

SELECT SUM(Asignadas),	SUM(Revision),		SUM(Devueltas),		SUM(Canceladas),	SUM(Rechazadas),	SUM(Autorizadas)
INTO Var_TotAsignadas,	Var_TotRevision, 	Var_TotDevueltas, 	Var_TotCanceladas,	Var_TotRechazadas,	Var_TotAutorizadas
FROM TMPPRODUCTIVIDADREP
WHERE Transaccion = Aud_NumTransaccion;

SET Var_TotAsignadas	:= IFNULL(Var_TotAsignadas,Entero_Cero);	
SET Var_TotRevision		:= IFNULL(Var_TotRevision,Entero_Cero); 	
SET Var_TotDevueltas	:= IFNULL(Var_TotDevueltas,Entero_Cero);
SET	Var_TotCanceladas	:= IFNULL(Var_TotCanceladas,Entero_Cero);
SET	Var_TotRechazadas	:= IFNULL(Var_TotRechazadas,Entero_Cero);
SET	Var_TotAutorizadas	:= IFNULL(Var_TotAutorizadas,Entero_Cero);

UPDATE TMPPRODUCTIVIDADREP 
	SET PendientesGlo = CASE WHEN (Var_TotAsignadas+Var_TotRevision) <= Entero_Cero THEN Entero_Cero 
								ELSE ROUND(100*(Asignadas+Revision)/(Var_TotAsignadas+Var_TotRevision),2) END,
		AutorizadasGlo = CASE WHEN Var_TotAutorizadas <= Entero_Cero THEN Entero_Cero 
								ELSE ROUND(100*(Autorizadas)/(Var_TotAutorizadas),2) END,
        PendientesInd = CASE WHEN (Asignadas+Revision+Canceladas+Rechazadas+Autorizadas) <= Entero_Cero THEN Entero_Cero
								ELSE ROUND(100*(Asignadas+Revision)/(Asignadas+Revision+Canceladas+Rechazadas+Autorizadas),2) END,
		TerminadasInd = CASE WHEN (Asignadas+Revision+Canceladas+Rechazadas+Autorizadas) <= Entero_Cero THEN Entero_Cero
								ELSE ROUND(100*(Canceladas+Rechazadas+Autorizadas)/(Asignadas+Revision+Canceladas+Rechazadas+Autorizadas),2) END
WHERE Transaccion = Aud_NumTransaccion;


SELECT SUM(PendientesGlo),	SUM(AutorizadasGlo)∫
INTO Var_TotPendientesGlo, Var_TotAutorizadasGlo
FROM TMPPRODUCTIVIDADREP
WHERE Transaccion = Aud_NumTransaccion;

SET	Var_TotPendientesGlo	:= IFNULL(Var_TotPendientesGlo,Entero_Cero);
SET	Var_TotAutorizadasGlo	:= IFNULL(Var_TotAutorizadasGlo,Entero_Cero);



SELECT Rep.UsuarioID,		IFNULL(Usu.NombreCompleto,'ANALISTA VIRTUAL')AS Nombre,		Rep.Asignadas, 		Rep.Revision AS EnRevision, 		Rep.Devueltas as Devoluciones, 
	   Rep.Canceladas, 		Rep.Rechazadas, 			Rep.Autorizadas, 			Rep.PendientesGlo AS PendGlobal, 	Rep.AutorizadasGlo AS AutGlobal, 
	   Rep.PendientesInd AS PendIndv, 	Rep.TerminadasInd AS Terminadas, 			Rep.TipoRegistro,
       Var_TotAsignadas AS TotalAsignadas,			Var_TotRevision AS TotalEnRevision, 		Var_TotDevueltas AS TotalDevueltas,				Var_TotCanceladas AS TotalCanceladas,		
       Var_TotRechazadas AS TotalRechazadas,			    Var_TotAutorizadas AS TotalAutorizadas,		Var_TotPendientesGlo AS TotalPorcPendGlobal,	Var_TotAutorizadasGlo AS TotalAutoriGlobal
FROM  TMPPRODUCTIVIDADREP Rep LEFT JOIN USUARIOS Usu
ON Rep.UsuarioID = Usu.UsuarioID
WHERE Transaccion = Aud_NumTransaccion;
-- AND Rep.UsuarioID <> Entero_Cero;



END TerminaStore$$