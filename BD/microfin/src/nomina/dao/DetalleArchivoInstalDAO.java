package nomina.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import nomina.bean.DetalleArchivoInstalBean;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class DetalleArchivoInstalDAO extends BaseDAO {

	/**
	 * Método que permite consultar la información de un listado de detalles de archivos de instalación.
	 * @param tipoLis Tipo de consulta a realizar.
	 * @param archivoInsta Información que guarda los filtros a usar.
	 * @return Listado de registros coincidentes con el filtro.
	 */
	public List<DetalleArchivoInstalBean> listaPrincipal(int tipoLis, final DetalleArchivoInstalBean archivoInsta){
		String query = "call DETALLEARCHIVOINSTALLIS(?,?,	?,?,?,?,?,	?,?);";//mapeo de los campos
		Object[] parametros = {	
				Utileria.convierteEntero(archivoInsta.getFolioID()),
				tipoLis,
			
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"EmpleadoNominaDAO.listaEmpleado",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DETALLEARCHIVOINSTALLIS(  " + Arrays.toString(parametros) + ")");

		List<DetalleArchivoInstalBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				DetalleArchivoInstalBean archivoInstal = new DetalleArchivoInstalBean();
				
				archivoInstal.setFolioID(resultSet.getString("FolioID"));
				archivoInstal.setCreditoID(resultSet.getString("CreditoID"));
				archivoInstal.setEstatus(resultSet.getString("Estatus"));
				archivoInstal.setDetalleArchivoID(resultSet.getString("DetalleArchivoID"));
				archivoInstal.setFechaLimiteRecep(resultSet.getString("FechaLimiteRecep"));

				return archivoInstal;
			}
		});
		return matches;
	}
}
