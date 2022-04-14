package cliente.dao;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import javax.sql.DataSource;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
 
import cliente.bean.FuncionesPubBean;

;

public class FuncionesPubDAO extends BaseDAO{
	
	public FuncionesPubDAO() {
	super();
	}

// ------------------ Transacciones ------------------------------------------

	//consulta de Funciones Publicas (PEPs)
	public FuncionesPubBean consulta(FuncionesPubBean funcion, int tipoConsulta) {
	//Query con el Store Procedure
	String query = "call FUNCIONESPUBCON(?,?,?,?,?,?,?,?,?);";
	Object[] parametros = {	funcion.getFuncionID(),
							tipoConsulta,
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							"FuncionesPubDAO.consulta",
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO};
	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FUNCIONESPUBCON(" + Arrays.toString(parametros) + ")");
	
			
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
		public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
			FuncionesPubBean funciones = new FuncionesPubBean();
				
			funciones.setFuncionID(String.valueOf(resultSet.getInt(1)));
			funciones.setDescripcion(resultSet.getString(2));	

				return funciones;

		}
	});
	return matches.size() > 0 ? (FuncionesPubBean) matches.get(0) : null;
			
}



	

//Lista de Funciones Publicas
public List listaFunciones(FuncionesPubBean funcion, int tipoLista) {
	//Query con el Store Procedure
	String query = "call FUNCIONESPUBLIS(?,?,?,?,?,?,?,?,?);";
	Object[] parametros = {	funcion.getDescripcion(),
							tipoLista,
							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"FuncionesPubDAO.listaFunciones",
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO};
	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FUNCIONESPUBLIS(" + Arrays.toString(parametros) + ")");
	
	
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
		public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
			FuncionesPubBean funcion = new FuncionesPubBean();		
			funcion.setFuncionID(String.valueOf(resultSet.getInt(1)));
			funcion.setDescripcion(resultSet.getString(2));					
			return funcion;				
		}
	});
			
	return matches;
}


}
