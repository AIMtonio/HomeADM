package bancaMovil.bean;

import general.bean.BaseBean;

import org.springframework.web.multipart.MultipartFile;

public class BAMImagenAntiphishingBean extends BaseBean {

	private MultipartFile file;
	private String imagenAntiphishingID;
	private String descripcion;
	private String estatus;
	private String imagenBinaria;

	public MultipartFile getFile() {
		return file;
	}

	public void setFile(MultipartFile file) {
		this.file = file;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getEstatus() {
		return estatus;
	}

	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}

	public String getImagenAntiphishingID() {
		return imagenAntiphishingID;
	}

	public void setImagenAntiphishingID(String imagenAntiphishingID) {
		this.imagenAntiphishingID = imagenAntiphishingID;
	}

	public String getImagenBinaria() {
		return imagenBinaria;
	}

	public void setImagenBinaria(String imagenBinaria) {
		this.imagenBinaria = imagenBinaria;
	}

}
