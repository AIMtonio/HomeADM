-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTESWSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTESWSLIS`;DELIMITER $$

CREATE PROCEDURE `CLIENTESWSLIS`(
	Par_Nombre				varchar(50),
	Par_InstitNominaID		int,
	Par_NegocioAfiliadoID	int,
	Par_NumLis				tinyint unsigned,
    Par_Segmento            int,

	Aud_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint
	)
TerminaStore: BEGIN




DECLARE	Cadena_Vacia	char(1);
DECLARE	Entero_Cero		int;
DECLARE	Fecha_Vacia		date;
DECLARE	Lis_ClientesIN	int;
DECLARE Lis_ClientesNA  int;
DECLARE Lis_Clientes	int;
DECLARE Lis_ClientesWS  int;
DECLARE Estatus_Activo  char(1);


Set	Cadena_Vacia		:= '';
Set	Entero_Cero			:= 0 ;
Set	Fecha_Vacia			:= '1900-01-01';
Set	Lis_ClientesIN		:= 1 ;
Set Lis_ClientesNA		:= 2 ;
Set Lis_Clientes 		:= 3 ;
Set Lis_ClientesWS 		:= 4 ;
Set Estatus_Activo      := 'A';

if(Par_NumLis = Lis_ClientesIN) then

 Select	Cli.ClienteID,	 NombreCompleto
 from   CLIENTES Cli
 inner join NOMINAEMPLEADOS Nem
 on  Cli.ClienteID=Nem.ClienteID
 where  Cli.NombreCompleto like concat("%",Par_Nombre, "%")
 and    Nem.InstitNominaID = Par_InstitNominaID
 limit 0, 15;

end if;

if(Par_NumLis = Lis_ClientesNA) then

 Select Cli.ClienteID, NombreCompleto
 from   CLIENTES Cli
 inner join NEGAFILICLIENTE Neg
 on  Cli.ClienteID=Neg.ClienteID
 where  Cli.NombreCompleto like concat("%",Par_Nombre, "%")
 and    Neg.NegocioAfiliadoID=Par_NegocioAfiliadoID
 limit 0, 15;

end if;

if(Par_NumLis = Lis_Clientes) then

  Select ClienteID, NombreCompleto
  from   CLIENTES
  where  NombreCompleto like concat("%",Par_Nombre, "%")
  limit  0, 15;

end if;



if(Par_NumLis = Lis_ClientesWS) then

			IF EXISTS (SELECT Cli.ClienteID
				FROM CLIENTES Cli,
					 PROMOTORES Pro
				WHERE Cli.PromotorActual = Pro.PromotorID
					AND Pro.Estatus = Estatus_Activo
					AND Cli.Estatus = Estatus_Activo
                    AND Pro.PromotorID = Par_Segmento
				LIMIT 1) THEN

				SELECT DISTINCT(Cli.ClienteID)	AS NumSocio,
						 RTRIM(
							CONCAT(
								Cli.PrimerNombre, ' ',
								IFNULL(Cli.SegundoNombre,Cadena_Vacia), ' ',
								IFNULL(Cli.TercerNombre,Cadena_Vacia))
							) 					AS Nombre,
						Cli.ApellidoPaterno		AS ApPaterno,
						Cli.ApellidoMaterno		AS ApMaterno,
						Cli.FechaNacimiento		AS FecNacimiento,
	                    IFNULL(Cli.RFC,Cadena_Vacia)AS Rfc
                       FROM CLIENTES Cli,
					 PROMOTORES Pro
				WHERE Cli.PromotorActual = Pro.PromotorID
					AND Pro.Estatus = Estatus_Activo
					AND Cli.Estatus = Estatus_Activo
                    AND Pro.PromotorID = Par_Segmento;

				ELSE
					SELECT  Cadena_Vacia	AS NumSocio,
							Cadena_Vacia	AS Nombre,
							Cadena_Vacia	AS ApPaterno,
							Cadena_Vacia	AS ApMaterno,
							Cadena_Vacia	AS FecNacimiento,
							Cadena_Vacia    AS Rfc;
			END IF;
		END IF;


END TerminaStore$$