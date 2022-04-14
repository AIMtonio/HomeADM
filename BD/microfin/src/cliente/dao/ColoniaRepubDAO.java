package cliente.dao;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
 
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;

import cliente.bean.ColoniaRepubBean;
import cliente.bean.LocalidadRepubBean;

public class ColoniaRepubDAO  extends BaseDAO{
	
	
	public ColoniaRepubDAO() {
		super();
	}
	public List listaColonias(ColoniaRepubBean colonia, int tipoLista) {
		//Query con el Store Procedure
		String query = "call COLONIASREPUBLIS(?,?,?,?,?, ?,?,?,?,? ,?);";
		Object[] parametros = {	colonia.getEstadoID(),
								colonia.getMunicipioID(),
								colonia.getAsentamiento(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"ColoniaRepubDAO.listaColonias",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call COLONIASREPUBLIS(" + Arrays.toString(parametros) + ")");	
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ColoniaRepubBean colonias = new ColoniaRepubBean();		
				colonias.setColoniaID(Utileria.completaCerosIzquierda(resultSet.getInt("ColoniaID"), 5));
				colonias.setNombreColonia(resultSet.getString("NombreColonia"));	
				return colonias;				
			}
		});
				
		return matches;
	}
	public ColoniaRepubBean consultaPrincipal(int estadoID, int municipioID,int coloniaID, int principal) {
		//Query con el Store Procedure
		String query = "call  COLONIASREPUBCON(?,?,?,?,?  ,?,?,?,?,?, ?);";
		Object[] parametros = {	estadoID,
								municipioID,
								coloniaID,
								principal,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ColoniaRepubDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call COLONIASREPUBCON((" + Arrays.toString(parametros) + ")");
		
				
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ColoniaRepubBean colonias = new ColoniaRepubBean();			
					
				colonias.setColoniaID(String.valueOf(resultSet.getInt("ColoniaID")));
				colonias.setAsentamiento(resultSet.getString("Asentamiento"));
				colonias.setCodigoPostal(resultSet.getString("CodigoPostal"));
						
					return colonias;
	
			}
		});
		return matches.size() > 0 ? (ColoniaRepubBean) matches.get(0) : null;
		
	}
	

}
