MODE ?= Release

# Создание conan-профиля с правильным компилятором.
conan-profile:
	@if conan profile list | grep -q "broker_client_profile"; then \
		echo "Conan profile 'broker_client_profile' already exists. Skipping creating profile..."; \
	else \
		echo "Creating broker_client_profile..." && \
		conan profile new broker_client_profile --detect && \
		conan profile update settings.compiler.libcxx=libstdc++11 broker_client_profile; \
	fi
	@echo "Setting ${MODE} mode..."
	@conan profile update settings.build_type=${MODE} broker_client_profile

# Загрузка и сборка зависимостей.
fetch:
	CMAKE_POLICY_VERSION_MINIMUM=3.5 conan install . -if build -pr=broker_client_profile --build=missing

# Сборка проекта.
build:
	cmake -B build . && cmake --build build

# Собрать проект.
debug:
	$(eval MODE := Debug)
	@true

# Дефолтный путь сборки.
all: conan-profile fetch build

# Очистка.
clean:
	@rm -rf build
	@rm -rf BrokerClient

.PHONY : conan-profile fetch build all debug