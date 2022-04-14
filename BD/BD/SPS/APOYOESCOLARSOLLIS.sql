-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APOYOESCOLARSOLLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `APOYOESCOLARSOLLIS`;DELIMITER $$

CREATE PROCEDURE `APOYOESCOLARSOLLIS`(

	Par_ClienteID				INT(11),
	Par_ApoyoEscSolID			varchar(11),
	Par_NombreCliente			varchar(200),
	Par_NumLis					TINYINT UNSIGNED,


	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
	)
TerminaStore:BEGIN




	DECLARE Lis_Principal		INT;
	DECLARE Lis_PorSolicitudID	INT;
	DECLARE Lis_PorSolicitudAut	INT;
	DECLARE Lis_PorSoliAutSuc 	INT;
	DECLARE Lis_Autorizados		INT;
	DECLARE Estatus_Reg			CHAR(1);
	DECLARE Estatus_Aut			char(1);
	DECLARE Lis_SolicitudAutCte	char(1);
	DECLARE Decimal_Cero		DECIMAL(12,2);
	DECLARE CadenaVacia         char(1);
	DECLARE Lis_PorSolicitudAutVen int(11);
	DECLARE Entero_Cero			INT;


	SET Lis_Principal		:=1;
	SET Lis_PorSolicitudID	:=2;
	SET Lis_PorSolicitudAut	:=3;
	SET Lis_SolicitudAutCte	:=4;
	SET Lis_Autorizados		:=5;
	SET Lis_PorSoliAutSuc   :=6;
	SET Lis_PorSolicitudAutVen :=7;
	SET Decimal_Cero		:=0.0;

	SET Estatus_Reg			:='R';
	set Estatus_Aut			:='A';
	SET CadenaVacia         :='';
	Set Entero_Cero			:=0;


		IF(Par_NumLis = Lis_Principal) THEN
			SELECT    AE.ApoyoEscSolID,		  AE.ClienteID,		  AE.EdadCliente,	  AC.Descripcion AS  ApoyoEscCicloID,	  AE.GradoEscolar,
					  AE.PromedioEscolar,	  AE.CicloEscolar,    FechaRegistro,	  U.NombreCompleto AS   UsuarioRegistra,  AE.Estatus,
					  FORMAT(AE.Monto,2) AS Monto,				  FechaAutoriza,	  FechaPago
			FROM	  APOYOESCOLARSOL AE INNER JOIN APOYOESCCICLO AC ON AE.ApoyoEscCicloID=AC.ApoyoEscCicloID
					  INNER JOIN USUARIOS U ON U.UsuarioID=AE.UsuarioRegistra
			WHERE 	  AE.ClienteID= Par_ClienteID AND AE.Estatus != Estatus_Reg;
		END IF;


		IF(Par_NumLis = Lis_Autorizados) THEN
			SELECT    AE.ApoyoEscSolID,		  AE.ClienteID,		  AE.EdadCliente,	  AC.Descripcion AS  ApoyoEscCicloID,	  AE.GradoEscolar,
					  AE.PromedioEscolar,	  AE.CicloEscolar,    FechaRegistro,	  U.NombreCompleto AS   UsuarioRegistra,  AE.Estatus,
					  FORMAT(AE.Monto,2) AS Monto
			FROM	  APOYOESCOLARSOL AE INNER JOIN APOYOESCCICLO AC ON AE.ApoyoEscCicloID=AC.ApoyoEscCicloID
					  INNER JOIN USUARIOS U ON U.UsuarioID=AE.UsuarioRegistra
			WHERE 	  AE.ClienteID= Par_ClienteID AND AE.Estatus = Estatus_Aut;
		END IF;



		IF(Par_NumLis = Lis_PorSolicitudID) THEN
			SELECT	AE.ApoyoEscSolID,		C.NombreCompleto
			FROM	APOYOESCOLARSOL AE INNER JOIN CLIENTES C ON AE.ClienteID = C.ClienteID
			WHERE 	AE.ClienteID= Par_ClienteID
			AND	 	AE.ApoyoEscSolID LIKE CONCAT("%", Par_ApoyoEscSolID, "%")
			ORDER BY AE.FechaRegistro
			limit 0, 15;
		END IF;

		IF(Par_NumLis = Lis_PorSolicitudAut) THEN
			SELECT	distinct(AE.ClienteID),		C.NombreCompleto,concat(ifnull(dc.calle,CadenaVacia),', ',ifnull(dc.Colonia,CadenaVacia)) as Direccion
				FROM	APOYOESCOLARSOL AE
				INNER JOIN CLIENTES C ON AE.ClienteID = C.ClienteID
				left join DIRECCLIENTE dc on C.ClienteID=dc.ClienteID and 	dc.Oficial='S'
				WHERE 	AE.Estatus = Estatus_Aut
				AND	 	C.NombreCompleto LIKE CONCAT("%", Par_NombreCliente, "%")

				limit 0, 15;
		END IF;

		IF(Par_NumLis = Lis_PorSolicitudAutVen) THEN
			IF ifnull(Par_ClienteID,Entero_Cero)>Entero_Cero THEN
			SELECT	distinct(AE.ClienteID),		C.NombreCompleto,concat(ifnull(dc.calle,CadenaVacia),', ',ifnull(dc.Colonia,CadenaVacia)) as Direccion
				FROM	APOYOESCOLARSOL AE
				INNER JOIN CLIENTES C ON AE.ClienteID = C.ClienteID
				left join DIRECCLIENTE dc on C.ClienteID=dc.ClienteID and dc.Oficial='S'
				WHERE 	C.ClienteID=Par_ClienteID
				AND 	AE.Estatus = Estatus_Aut
				AND	 	C.NombreCompleto LIKE CONCAT("%", Par_NombreCliente, "%")
				limit 0, 50;
			ELSE
			SELECT	distinct AE.ClienteID,		C.NombreCompleto,concat(ifnull(dc.calle,CadenaVacia),', ',ifnull(dc.Colonia,CadenaVacia)) as Direccion
				FROM	APOYOESCOLARSOL AE
				INNER JOIN CLIENTES C ON AE.ClienteID = C.ClienteID
				left join DIRECCLIENTE dc on C.ClienteID=dc.ClienteID and dc.Oficial='S'
				WHERE 	AE.Estatus = Estatus_Aut
				AND	 	C.NombreCompleto LIKE CONCAT("%", Par_NombreCliente, "%")
				limit 0, 50;
			END IF;
		END IF;

		IF(Par_NumLis = Lis_PorSoliAutSuc) THEN
			SELECT	distinct(AE.ClienteID),		C.NombreCompleto,concat(ifnull(dc.calle,CadenaVacia),', ',ifnull(dc.Colonia,CadenaVacia)) as Direccion
				FROM	APOYOESCOLARSOL AE
				INNER JOIN CLIENTES C ON AE.ClienteID = C.ClienteID
				left join DIRECCLIENTE dc on C.ClienteID=dc.ClienteID and 	dc.Oficial='S'
				WHERE 	AE.Estatus = Estatus_Aut
				AND	 	C.NombreCompleto LIKE CONCAT("%", Par_NombreCliente, "%")
				and 	C.SucursalOrigen=Aud_Sucursal
				limit 0, 25;
		END IF;

		IF(Par_NumLis = Lis_SolicitudAutCte) THEN
			SELECT	AE.ApoyoEscSolID, concat(convert(AE.ApoyoEscSolID,char)," - ",
												convert(format(IFNULL(AE.Monto,Decimal_Cero),2), char),"  -  ",
												convert(AE.FechaAutoriza,char)) as Descripcion
				FROM	APOYOESCOLARSOL AE
				WHERE 	AE.ClienteID = Par_ClienteID
				AND AE.Estatus = Estatus_Aut;
		END IF;

	END TerminaStore$$