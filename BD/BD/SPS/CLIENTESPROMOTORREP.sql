-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTESPROMOTORREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTESPROMOTORREP`;DELIMITER $$

CREATE PROCEDURE `CLIENTESPROMOTORREP`(
	Par_SucursalID			INT(11),		-- ID DE LA SUCURSAL, 0 - TODAS
	Par_PromotorID			INT(11),		-- ID DEL PROMOTOR, 0 - TODOS
	Par_Genero				VARCHAR(1),		-- GENERO DE LOS CLIENTES , '' - TODOS
	Par_EstadoID 			INT(11),		-- ID DEL ESTADO, 0 - TODOS.
	Par_MunicipioID			INT(11),		-- ID DEL MUNICIPIO, 0 - TODOS

	Par_CreditoEst			VARCHAR(1),		-- ESTATUS DEL CREDITO, '' - TODOS, V - VIGENTE, B - VENCIDOS
	/* Parametros de Auditoria */
    Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATE,
	Aud_DireccionIP			VARCHAR(15),

	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore:BEGIN
-- Declaracion de Variables
DECLARE Var_Sentencia 		VARCHAR(60000);

-- Declaracion de Conatantes
DECLARE Entero_Cero 		INT;
DECLARE Cadena_Vacia 		CHAR(1);

-- Asignacion de Constantes
SET Entero_Cero				:=0;
SET Cadena_Vacia			:='';

SET Par_SucursalID 	:=IFNULL(Par_SucursalID,Entero_Cero);
SET Par_MunicipioID	:=IFNULL(Par_MunicipioID, Entero_Cero);
SET Par_PromotorID	:=IFNULL(Par_PromotorID,Entero_Cero);
SET Par_EstadoID	:=IFNULL(Par_EstadoID, Entero_Cero);
SET Par_Genero		:=IFNULL(Par_Genero, '');
SET Par_CreditoEst	:=IFNULL(Par_CreditoEst, '');

		DROP TABLE IF EXISTS CLIENTEPRO;
		CREATE TEMPORARY TABLE  CLIENTEPRO (
		ClienteID		INT (11),
		NombreCompleto	VARCHAR(100),
		FechaAlta		DATE,
		EsMenorEdad		CHAR(1),
		PromotorInicial	INT(11),
		PromotorActual	INT(11),
		SucursalID		INT (11),
		NombreSucursal	VARCHAR(200),
		Direccion		VARCHAR(200),
		NombrePromotorActual VARCHAR(200),
		NombrePromotorInicial VARCHAR(200),
		EstadoID			INT(11),
		MunicipioID			INT(11),
		NombreEstado		VARCHAR(100),
		NombreMuncipio		VARCHAR(100),
		CreditoID			BIGINT(12),
		SolicitudCreditoID	INT(11),
		Sexo				CHAR(1),
		PRIMARY KEY (CreditoID) );

	SET Var_Sentencia	:=  '
		insert into CLIENTEPRO (ClienteID,	NombreCompleto, FechaAlta,	EsMenorEdad	,PromotorInicial,
								SolicitudCreditoID,CreditoID,PromotorActual,Sexo)
		select Cli.ClienteID,Cli.NombreCompleto,Cli.FechaAlta,Cli.EsMenorEdad,Cli.PromotorInicial,
				Cre.SolicitudCreditoID,Cre.CreditoID,Cli.PromotorActual,Cli.Sexo
		from CLIENTES Cli ,
			 CREDITOS Cre
		where Cre.ClienteID=Cli.ClienteID';

	IF Par_CreditoEst = "" THEN
		SET Var_Sentencia	:=CONCAT(Var_Sentencia,'
				 and Cre.Estatus in("V","B") ');
	ELSE
		SET Var_Sentencia	:=CONCAT(Var_Sentencia,'
				 and Cre.Estatus= "',Par_CreditoEst,'"');
	END IF;

		SET @Sentencia1	= (Var_Sentencia);
		PREPARE OPERACIONESVENT1 FROM @Sentencia1;
		EXECUTE OPERACIONESVENT1;
		DEALLOCATE PREPARE OPERACIONESVENT1;

	UPDATE CLIENTEPRO Cli ,
		   DIRECCLIENTE Dir
	SET Cli.Direccion   =Dir.DireccionCompleta,
		Cli.EstadoID	=Dir.EstadoID,
		Cli.MunicipioID =Dir.MunicipioID
	WHERE Cli.ClienteID = Dir.ClienteID
	AND Dir.Oficial="S";

	UPDATE CLIENTEPRO Cli ,
		   PROMOTORES Pro
		SET Cli.NombrePromotorInicial = Pro.NombrePromotor
		WHERE Cli.PromotorInicial=Pro.PromotorID	;


	UPDATE CLIENTEPRO Cli ,
		   ESTADOSREPUB Est
		SET Cli.NombreEstado = Est.Nombre
		WHERE Cli.EstadoID=Est.EstadoID	;


	UPDATE CLIENTEPRO Cli ,
		   MUNICIPIOSREPUB Mun
		SET Cli.NombreMuncipio = Mun.Nombre
		WHERE Cli.MunicipioID=Mun.MunicipioID;


	UPDATE CLIENTEPRO Cli ,
		   SOLICITUDCREDITO Sol
		SET Cli.PromotorActual = Sol.PromotorID
		WHERE Cli.SolicitudCreditoID=Sol.SolicitudCreditoID;

	UPDATE CLIENTEPRO Cli ,
		   PROMOTORES Pro
		SET Cli.NombrePromotorActual = Pro.NombrePromotor,
			Cli.SucursalID			 =Pro.SucursalID
		WHERE Cli.PromotorActual=Pro.PromotorID	;

	UPDATE CLIENTEPRO Cli ,
		   SUCURSALES Suc
		SET Cli.NombreSucursal=Suc.NombreSucurs
		WHERE Cli.SucursalID=Suc.SucursalID;


	SET Var_Sentencia	:='
			Select 			ClienteID,							MAX(NombreCompleto) AS NombreCompleto, 		MAX(FechaAlta) AS FechaAlta,
							MAX(EsMenorEdad) AS EsMenorEdad,	MAX(PromotorInicial) AS PromotorInicial, 	MAX(PromotorActual) AS PromotorActual,
                            MAX(SucursalID) AS SucursalID,		MAX(NombreSucursal) AS NombreSucursal,		MAX(Direccion) AS Direccion,
                            MAX(NombrePromotorActual) AS NombrePromotorActual ,	MAX(NombrePromotorInicial) AS NombrePromotorInicial,
                            MAX(EstadoID) AS EstadoID,			MAX(MunicipioID) AS MunicipioID,			MAX(NombreEstado) AS NombreEstado,
                            MAX(NombreMuncipio) AS NombreMuncipio
			from CLIENTEPRO ';


 IF Par_SucursalID > Entero_Cero  THEN
	SET Var_Sentencia	:=CONCAT(Var_Sentencia,' where SucursalID= ',Par_SucursalID);
	IF Par_PromotorID > Entero_Cero THEN
		SET Var_Sentencia	:=CONCAT(Var_Sentencia,'  and PromotorActual= ',Par_PromotorID);
	END IF;
	IF Par_Genero != '' THEN
		SET Var_Sentencia	:=CONCAT(Var_Sentencia,'  and Sexo= "',Par_Genero,'"');
	END IF;
	IF Par_EstadoID > Entero_Cero THEN
		SET Var_Sentencia	:=CONCAT(Var_Sentencia,'  and EstadoID= ',Par_EstadoID);
		IF Par_MunicipioID > Entero_Cero THEN
			SET Var_Sentencia	:=CONCAT(Var_Sentencia,'  and MunicipioID=',Par_MunicipioID);
		END IF;
	END IF;

 ELSE
	IF Par_PromotorID > Entero_Cero THEN
		SET Var_Sentencia	:=CONCAT(Var_Sentencia,' where  PromotorActual= ',Par_PromotorID);
		IF Par_Genero != '' THEN
			SET Var_Sentencia	:=CONCAT(Var_Sentencia,'  and Sexo= "',Par_Genero,'"');
		END IF;
		IF Par_EstadoID > Entero_Cero THEN
			SET Var_Sentencia	:=CONCAT(Var_Sentencia,'  and EstadoID= ',Par_EstadoID);
			IF Par_MunicipioID > Entero_Cero THEN
				SET Var_Sentencia	:=CONCAT(Var_Sentencia,'  and MunicipioID=',Par_MunicipioID);
			END IF;
		END IF;
	ELSE
		IF  Par_Genero != '' THEN
			SET Var_Sentencia	:=CONCAT(Var_Sentencia,'  where  Sexo= "',Par_Genero,'"');
			IF Par_EstadoID > Entero_Cero THEN
				SET Var_Sentencia	:=CONCAT(Var_Sentencia,'  and EstadoID= ',Par_EstadoID);
				IF Par_MunicipioID > Entero_Cero THEN
					SET Var_Sentencia	:=CONCAT(Var_Sentencia,'  and MunicipioID=',Par_MunicipioID);
				END IF;
			END IF;
		ELSE
			IF Par_EstadoID > Entero_Cero THEN
				SET Var_Sentencia	:=CONCAT(Var_Sentencia,'  where EstadoID= ',Par_EstadoID);
				IF Par_MunicipioID > Entero_Cero THEN
					SET Var_Sentencia	:=CONCAT(Var_Sentencia,'  and MunicipioID=',Par_MunicipioID);
				END IF;
			END IF;
		END IF;
	END IF;
 END IF;

 SET Var_Sentencia	:=CONCAT(Var_Sentencia,' group by ClienteID order by SucursalID , PromotorActual,  ClienteID ;');


	SET @Sentencia	= (Var_Sentencia);

   PREPARE STREPCLIENTES FROM @Sentencia;
   EXECUTE STREPCLIENTES;
   DEALLOCATE PREPARE STREPCLIENTES;

END	TerminaStore$$