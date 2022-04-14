-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RELACIONCLIEMPLEADOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `RELACIONCLIEMPLEADOCON`;DELIMITER $$

CREATE PROCEDURE `RELACIONCLIEMPLEADOCON`(




	Par_ClienteID			INT(10),
	Par_ProspectoID			INT(10),

	Par_NumCon				TINYINT UNSIGNED,


	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
	)
TerminaStore:BEGIN


	DECLARE Var_ClasificacionCli		CHAR(1);



	DECLARE Con_Principal		INT;

	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Entero_Cero			INT(1);
	DECLARE CliFuncionario		CHAR(1);
	DECLARE CliEmpleado			CHAR(1);
	DECLARE Estatus_Activo		CHAR(1);
	DECLARE RelacionGrado1		INT(2);
	DECLARE RelacionGrado2		INT(2);


	SET Con_Principal			:=1;

	SET Cadena_Vacia			:='';
	SET Entero_Cero				:=0;
	SET CliFuncionario			:='O';
	SET CliEmpleado				:='E';
	SET Estatus_Activo			:='A';
	SET RelacionGrado1			:=1;
	SET RelacionGrado2			:=2;



		IF(Par_NumCon = Con_Principal) THEN
				IF(IFNULL(Par_ClienteID,Entero_Cero) > Entero_Cero)THEN
					SET Var_ClasificacionCli := (SELECT Clasificacion FROM CLIENTES
													WHERE ClienteID = Par_ClienteID
														AND Estatus = Estatus_Activo
														AND (Clasificacion = CliFuncionario
														OR Clasificacion = CliEmpleado));

					IF(IFNULL(Var_ClasificacionCli,Cadena_Vacia) != Cadena_Vacia)THEN
						SELECT Par_ClienteID		AS ClienteID,
							   Var_ClasificacionCli	AS Clasificacion;

					ELSE
						SELECT Cli.ClienteID, 	Cli.Clasificacion
							FROM RELACIONCLIEMPLEADO Rel,
								 CLIENTES Cli,
								 TIPORELACIONES Tip
							WHERE Cli.ClienteID = Rel.RelacionadoID
								AND  Rel.ClienteID = Par_ClienteID
								AND Cli.Estatus = Estatus_Activo
								AND	Rel.ParentescoID = Tip.TipoRelacionID
								AND (Tip.Grado = RelacionGrado1 OR Tip.Grado = RelacionGrado2)
								AND (Cli.Clasificacion = CliFuncionario OR Cli.Clasificacion = CliEmpleado);
					END IF;


				ELSE
					SELECT ProspectoID AS ClienteID, Clasificacion FROM PROSPECTOS
						WHERE ProspectoID = Par_ProspectoID
							AND (Clasificacion = CliFuncionario
							OR Clasificacion = CliEmpleado);
				END IF;

		END IF;


	END TerminaStore$$