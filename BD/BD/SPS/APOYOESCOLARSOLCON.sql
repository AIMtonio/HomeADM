-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APOYOESCOLARSOLCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `APOYOESCOLARSOLCON`;DELIMITER $$

CREATE PROCEDURE `APOYOESCOLARSOLCON`(

	Par_ClienteID			INT(11),
	Par_ApoyoEscSolID		INT(11),
	Par_NumCon				TINYINT UNSIGNED,


	Par_EmpresaID			INT(11),
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
	)
TerminaStore:BEGIN




	DECLARE Con_Principal		INT;
	DECLARE Con_Solicitud		INT;
	DECLARE Estatus_Reg			CHAR(1);


	SET Con_Principal			:=1;
	SET Con_Solicitud			:=2;


	SET Estatus_Reg				:='R';



		IF(Par_NumCon = Con_Principal) THEN
			SELECT   AE.ApoyoEscSolID,	  ClienteID,		  EdadCliente,	   AE.ApoyoEscCicloID, 		GradoEscolar,
					  PromedioEscolar,	  CicloEscolar,       NombreEscuela,   DireccionEscuela,	    UsuarioRegistra,
					  UsuarioAutoriza,    Estatus,			  FechaRegistro,   FechaAutoriza,		    FechaPago,
					  FORMAT(Monto,2) AS Monto,	 			  TransaccionPago, PolizaID, 	  			CajaID,
					  SucursalCajaID,		SucursalRegistroID,Comentario,		C.Descripcion
			FROM	APOYOESCOLARSOL AE INNER JOIN APOYOESCCICLO C on AE.ApoyoEscCicloID = C.ApoyoEscCicloID
			WHERE	ClienteID = Par_ClienteID AND ApoyoEscSolID=Par_ApoyoEscSolID;
		END IF;

		IF(Par_NumCon = Con_Solicitud) THEN
			SELECT    AE.ApoyoEscSolID,	  	  AE.ClienteID,		  AE.EdadCliente,	   AE.ApoyoEscCicloID, 		AE.GradoEscolar,
					  AE.PromedioEscolar,	  AE.CicloEscolar,    AE.NombreEscuela,    AE.DireccionEscuela,	    U.NombreCompleto AS UsuarioRegistra,
					  UsuarioAutoriza,    	  AE.Estatus,		  AE. FechaRegistro,   FechaAutoriza,		    AE.FechaPago,
					  FORMAT(Monto,2) AS Monto,	 			 	  AE.TransaccionPago,  AE.PolizaID, 	  		AE.CajaID,
					  AE.SucursalCajaID,	  AE.SucursalRegistroID,  AE.Comentario,   '' AS Descripcion
			FROM	APOYOESCOLARSOL AE INNER JOIN USUARIOS U ON AE.UsuarioRegistra= U.UsuarioID
			WHERE	AE.ApoyoEscSolID=Par_ApoyoEscSolID;
		END IF;


	END TerminaStore$$